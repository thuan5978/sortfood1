import 'package:flutter/material.dart';
import 'package:sortfood/ui/payment_choose/stripe_page.dart';

enum PaymentMethod { cashOnDelivery, bankTransfer, paypal, stripe }

class PaymentPage extends StatefulWidget {
  final double totalPrice; 

  const PaymentPage({super.key, required this.totalPrice}); 

  @override
  PaymentPageState createState() => PaymentPageState();
}

class PaymentPageState extends State<PaymentPage> {
  PaymentMethod? selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Payment', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose Payment Method',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildPaymentOption(PaymentMethod.cashOnDelivery, 'Cash on Delivery'),
          _buildPaymentOption(PaymentMethod.bankTransfer, 'Bank Transfer'),
          _buildPaymentOption(PaymentMethod.paypal, 'PayPal'),
          _buildPaymentOption(PaymentMethod.stripe, 'Stripe'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _handlePayment,
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(PaymentMethod method, String methodName) {
    return ListTile(
      title: Text(methodName),
      leading: Radio<PaymentMethod>(
        value: method,
        groupValue: selectedPaymentMethod,
        onChanged: (value) {
          setState(() {
            selectedPaymentMethod = value;
          });
        },
      ),
    );
  }

  void _handlePayment() {
    String message;

    if (selectedPaymentMethod == PaymentMethod.bankTransfer) {
      message = 'Bạn đã chọn Bank Transfer.';
    } else if (selectedPaymentMethod == PaymentMethod.paypal) {
      message = 'Bạn đã chọn PayPal.';
    } else if (selectedPaymentMethod == PaymentMethod.stripe) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StripePaymentPage(totalPrice: widget.totalPrice), 
        ),
      );
      return; 
    } else {
      message = 'Bạn đã chọn Cash on Delivery.';
    }

    _showDialog('Confirmation', '$message Tổng số tiền: ${widget.totalPrice} VND');
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void navigateToPaymentPage(BuildContext context, double totalPrice) { 
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(totalPrice: totalPrice), 
      ),
    );
  }
}
