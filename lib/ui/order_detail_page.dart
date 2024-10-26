import 'package:flutter/material.dart';
import 'package:sortfood/model/ordersdetail.dart';
import 'package:sortfood/api/airtableservice.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';
import 'package:sortfood/ui/payment_page.dart';

class OrdersDetailPage extends StatefulWidget {
  final int? orderId;

  const OrdersDetailPage({super.key, required this.orderId});

  @override
  OrdersDetailPageState createState() => OrdersDetailPageState();
}

class OrdersDetailPageState extends State<OrdersDetailPage> {
  OrdersDetail? orderDetail;
  bool isLoading = true;
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    _fetchOrderDetail();
  }

    Future<void> _fetchOrderDetail() async {
    try {
      final airtableService = AirtableService();
      final orderId = widget.orderId?.toInt();

      if (orderId != null) {
        orderDetail = await airtableService.fetchOrdersDetailById(orderId);
        if (orderDetail == null) {
          logger.w('Order not found: $orderId');
        } else {
          logger.i('Order detail fetched: ${orderDetail?.id }');
        }
      } else {
        logger.e('Order ID is null');
        orderDetail = null;
      }
    } catch (e) {
      logger.e('Error fetching order detail for ID ${widget.orderId}: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Order Details'),
    ),
    body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : orderDetail == null
            ? const Center(child: Text('Order not found or doesn\'t exist.'))
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order ID: ${orderDetail!.id}', style: Theme.of(context).textTheme.titleLarge),
                    Text('User ID: ${orderDetail!.userId}', style: Theme.of(context).textTheme.bodyMedium),
                    Text('Payment Method: ${orderDetail!.paymentMethod}', style: Theme.of(context).textTheme.bodyMedium),
                    Text('Status: ${orderDetail!.status}', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 16.0),
                    Text('Products:', style: Theme.of(context).textTheme.titleLarge),
                    Expanded(
                      child: ListView.builder(
                        itemCount: orderDetail!.products.length,
                        itemBuilder: (context, index) {
                          final product = orderDetail!.products[index];
                          return ListTile(
                            title: Text(product.name ?? 'Unknown Product'),
                            subtitle: Text('Quantity: ${product.quantity}'),
                            trailing: Text('Total: ${NumberFormat.simpleCurrency().format(product.price * product.quantity)}'),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PaymentPage(orderDetail: orderDetail!)),
                        );
                      },
                      child: const Text('Proceed to Payment'),
                    ),
                  ],
                ),
              ),
  );
}

}
