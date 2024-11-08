import 'package:flutter/material.dart';
import 'package:sortfood/model/products.dart';
import 'package:logger/logger.dart';
import 'package:sortfood/model/orders.dart';
import 'package:sortfood/ui/order_detail_page.dart';
import 'package:sortfood/model/ordersdetail.dart';

class CartPage extends StatefulWidget {
  final int userId;
  final String userName;
  final String address;
  final String paymentMethod;
  final List<Products> cartProducts; 

  const CartPage({
    required this.userId,
    required this.userName,
    required this.address,
    required this.paymentMethod,
    required this.cartProducts, 
    super.key,
  });

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    double totalPrice = _calculateTotalPrice();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
        
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildCartProductList(),
          ),
          _buildCartSummary(context, totalPrice),
        ],
      ),
    );
  }

  double _calculateTotalPrice() {
    return widget.cartProducts.fold(0, (sum, product) => sum + product.price);
  }

  Widget _buildCartProductList() {
    return widget.cartProducts.isNotEmpty
        ? ListView.builder(
            itemCount: widget.cartProducts.length,
            itemBuilder: (context, index) {
              final product = widget.cartProducts[index];
              return Padding(
                padding: const EdgeInsets.all(10),
                child: _itemProduct(product, index),
              );
            },
          )
        : const Center(
            child: Text(
              'Giỏ hàng trống',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
  }

  Widget _itemProduct(Products product, int index) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                product.img,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name!,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  "${product.price.toStringAsFixed(0)} VND", // Hiển thị giá với 0 chữ số thập phân
                  style: const TextStyle(fontSize: 16, color: Colors.orange),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _removeProduct(index),
          ),
        ],
      ),
    );
  }

  void _removeProduct(int index) {
    setState(() {
      widget.cartProducts.removeAt(index);
    });
  }

  Widget _buildCartSummary(BuildContext context, double totalPrice) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tổng tiền:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${totalPrice.toStringAsFixed(0)} VND',
                style: const TextStyle(fontSize: 18, color: Colors.orange),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              _onCheckoutPressed(context, totalPrice);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: const Text(
              'Thanh toán',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _onCheckoutPressed(BuildContext context, double totalPrice) {
    if (widget.cartProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Giỏ hàng trống, vui lòng thêm sản phẩm.'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Xác nhận thanh toán'),
            content: Text('Bạn có chắc chắn muốn thanh toán tổng số tiền: ${totalPrice.toStringAsFixed(0)} VND?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  final order = _createOrder(totalPrice);
                  Navigator.of(context).pop(); 
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrdersDetailPage(orderdetailID: order.id),
                    ),
                  );
                },
                child: const Text('Xác nhận'),
              ),
            ],
          );
        },
      );
    }
  }

    Order _createOrder(double totalPrice) {
  final existingOrders = [];

  int nextCartID = existingOrders.isNotEmpty
      ? existingOrders.map((order) => order.cartId).reduce((a, b) => a > b ? a : b) + 1
      : 1;

  final orderId = DateTime.now().millisecondsSinceEpoch.toInt();

    final order = Order(
      id: orderId,
      userId: widget.userId,
      name: widget.userName,
      address: widget.address,
      dateCreated: DateTime.now(),
      cartId: nextCartID,
      quantity: widget.cartProducts.length,
      totalPrice: totalPrice,
      deliveryDate: DateTime.now().add(const Duration(days: 1)),
      paymentMethod: widget.paymentMethod,
      status: ["pending"],
    );

    existingOrders.add(order); 

    
    final orderDetail = OrdersDetail(
      id: orderId, 
      orderId: orderId,
      products: widget.cartProducts,
      totalPrice: totalPrice,
    );
    return order;
  }
}
