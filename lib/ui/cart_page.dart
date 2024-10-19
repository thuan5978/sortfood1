import 'package:flutter/material.dart';
import 'package:sortfood/ui/home_screen.dart';
import 'package:sortfood/api/airtableservice.dart';
import 'package:sortfood/model/products.dart';

class CartPage extends StatelessWidget {
  final List<Products> cartProducts;

  const CartPage({super.key, required this.cartProducts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Cart', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    if (cartProducts.isEmpty) {
      return const Center(
        child: Text('Your cart is empty'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cartProducts.length,
      itemBuilder: (context, index) {
        final product = cartProducts[index];
        return ListTile(
          leading: Image.network(product.img!, width: 50, height: 50),
          title: Text(product.name ?? ''),
          subtitle: Text('${product.price?.toStringAsFixed(3)} VND'),
        );
      },
    );
  }
}
