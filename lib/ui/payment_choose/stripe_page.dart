import 'package:flutter/material.dart';
import 'package:sortfood/model/ordersdetail.dart';

class StripePaymentPage extends StatelessWidget {
  final OrdersDetail orderDetail; 

  const StripePaymentPage({super.key, required this.orderDetail}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Payment'),
      ),
      body: Center(
        child: Text('ID đơn hàng: ${orderDetail.id}'), 
      ),
    );
  }
}
