import 'package:flutter/material.dart';

class StripePaymentPage extends StatelessWidget {
  final double totalPrice; 

  const StripePaymentPage({super.key, required this.totalPrice}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Payment'),
      ),
      body: Center(
        child: Text('Tổng số tiền: $totalPrice VND'), 
      ),
    );
  }
}
