import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sortfood/model/ordersdetail.dart';
import 'package:sortfood/api/airtableservice.dart';
import 'package:logger/logger.dart';

class StripeService {
  final String apiKey = dotenv.env['STRIPE_SECRET_KEY'] ?? '';
  final Logger logger = Logger();

  Future<Map<dynamic, dynamic>> createPaymentLink(OrdersDetail orderDetail) async {
    if (apiKey.isEmpty) {
      throw Exception('Stripe API key is not configured.');
    }

    try {
      
      String productImage = orderDetail.productImages != null && orderDetail.productImages!.isNotEmpty
          ? orderDetail.productImages![0]
          : ''; 

      double productPrice = orderDetail.productPrices != null && orderDetail.productPrices!.isNotEmpty
          ? orderDetail.productPrices![0] * 100 
          : 0.0; 

      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_links'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'line_items': [
            {
              'price_data': {
                'currency': 'vnd',
                'product_data': {
                  'name': orderDetail.name ?? 'Unknown Product',
                  'images': [productImage],
                },
                'unit_amount': productPrice.toInt(), 
              },
              'quantity': orderDetail.cartQuantity ?? 1,
            }
          ],
          'shipping_address_collection': {
            'allowed_countries': ['VN'],
          },
          'metadata': {
            'order_id': orderDetail.id.toString(),
          },
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Stripe API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating Stripe Payment Link: $e');
    }
  }

  Future<void> handlePayment(int orderDetailId) async {
    try {
      AirtableService airtableService = AirtableService();
      OrdersDetail orderDetail = await airtableService.fetchOrdersDetailById(orderDetailId);

      StripeService stripeService = StripeService();
      final paymentLinkData = await stripeService.createPaymentLink(orderDetail);

      final paymentLinkUrl = paymentLinkData['url'];
      logger.i('Payment Link: $paymentLinkUrl');
    } catch (e) {
      throw Exception('Error processing payment: $e');
    }
  }
}
