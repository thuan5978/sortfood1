import 'package:flutter/material.dart';
import 'package:sortfood/model/ordersdetail.dart';
import 'package:sortfood/api/airtableservice.dart';
import 'package:logger/logger.dart';
import 'package:sortfood/ui/payment_page.dart';
import 'package:sortfood/model/products.dart';

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
      final orderId = widget.orderId;

      if (orderId != null) {
        orderDetail = await airtableService.fetchOrdersDetailById(orderId);
        if (orderDetail == null) {
          logger.w('Order not found: $orderId');
        } else {
          logger.i('Order detail fetched: ${orderDetail?.id}');
        }
      } else {
        logger.e('Order ID is null');
      }
    } catch (e) {
      logger.e('Error fetching order detail for ID ${widget.orderId}: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildProductSection() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (orderDetail?.products.isNotEmpty == true) {
      return _buildProductList(orderDetail!.products);
    } else {
      return const Center(child: Text('Giỏ hàng trống', style: TextStyle(fontSize: 16, color: Colors.grey)));
    }
  }

  Widget _buildProductList(List<Products> products) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Padding(
          padding: const EdgeInsets.all(10),
          child: _itemProduct(product, index),
        );
      },
    );
  }

  Widget _itemProduct(Products product, int index) {
    int quantity = product.quantity;

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                product.img,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? 'Unknown Product',
                  style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  "${product.price.toStringAsFixed(3)} VND",
                  style: const TextStyle(color: Colors.orange, fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          quantity++;
                          product.quantity = quantity;
                        });
                      },
                      icon: const Icon(Icons.add, color: Colors.blue, size: 30),
                    ),
                    Text('$quantity', style: const TextStyle(fontSize: 18)),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (quantity > 1) {
                            quantity--;
                            product.quantity = quantity;
                          }
                        });
                      },
                      icon: const Icon(Icons.remove, color: Colors.blue, size: 30),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          orderDetail?.products.removeAt(index);
                        });
                      },
                      icon: const Icon(Icons.delete, color: Colors.red, size: 30),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductSection(),
            const SizedBox(height: 20),
            if (!isLoading && orderDetail != null) ...[
              Text(
                'Tổng số tiền: ${orderDetail!.totalPrice?.toStringAsFixed(3)} VND',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentPage(orderDetail: orderDetail!)),
                  );
                },
                child: const Text('Thanh toán'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
