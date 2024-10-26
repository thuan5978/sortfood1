import 'package:flutter/material.dart';

class PayPalPage extends StatelessWidget {
  const PayPalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PayPal')),
      body: const Center(child: Text('PayPal Payment Page')),
    );
  }
}