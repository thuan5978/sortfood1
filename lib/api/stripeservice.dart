import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sortfood/model/ordersdetail.dart';
import 'package:sortfood/api/airtableservice.dart';
import 'package:logger/logger.dart';

class StripeService {
  final String stripeSecretKey = dotenv.env['STRIPE_SECRET_KEY'] ?? '';
  final String stripePublishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  final Logger logger = Logger();

  Future<Map<dynamic, dynamic>> createPaymentIntent(OrdersDetail orderDetail) async {
    if (stripeSecretKey.isEmpty) {
      throw Exception('Stripe API key is not configured.');
    }

    try {
      double productPrice = (orderDetail.productPrices?.isNotEmpty == true ? orderDetail.productPrices![0] : 0.0) * 100;

      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $stripeSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': productPrice.toInt().toString(),
          'currency': 'vnd',
          'payment_method_types[]': 'card',
          'metadata[order_id]': orderDetail.id.toString(),
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Stripe API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      logger.e('Error creating Stripe Payment Intent: $e');
      throw Exception('Error creating Stripe Payment Intent: $e');
    }
  }

  Future<void> handlePayment(int orderDetailId) async {
    try {
      AirtableService airtableService = AirtableService();
      OrdersDetail orderDetail = await airtableService.fetchOrdersDetailById(orderDetailId);

      final paymentIntentData = await createPaymentIntent(orderDetail);
      final clientSecret = paymentIntentData['client_secret'];
      logger.i('Payment Intent Client Secret: $clientSecret');
    } catch (e) {
      logger.e('Error processing payment: $e');
      throw Exception('Error processing payment: $e');
    }
  }
}
