import 'package:flutter/material.dart';

class BankTransferPage extends StatelessWidget {
  const BankTransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bank Transfer')),
      body: const Center(child: Text('Bank Transfer Payment Page')),
    );
  }
}