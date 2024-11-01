import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sortfood/model/orders.dart';
import 'package:sortfood/api/airtableservice.dart';
import 'package:sortfood/ui/order_detail_page.dart';

class OrderPage extends StatefulWidget {
  final bool isLoading;

  const OrderPage({super.key, this.isLoading = false});

  @override
  OrderPageState createState() => OrderPageState();
}

class OrderPageState extends State<OrderPage> {
  final Logger logger = Logger();

  Future<List<Order>> _getFilteredOrders(BuildContext context) async {
    final AirtableService airtableService = AirtableService();

    try {
      final orders = await airtableService.fetchOrders();
      logger.i('Fetched Orders: ${orders.map((e) => e.toJson()).toList()}');

      final filteredOrders = orders.where((order) {
        final hasPendingStatus = order.status.contains('Pending');
        return hasPendingStatus;
      }).toList();

      logger.i('Filtered Orders: ${filteredOrders.map((e) => e.toJson()).toList()}');

      return filteredOrders;
    } catch (e) {
      logger.e("Error fetching filtered orders: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
        title: const Text('Đơn hàng', style: TextStyle(color: Colors.white)),
      ),
      body: widget.isLoading ? _buildLoadingIndicator() : _buildOrderSection(context),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildOrderSection(BuildContext context) {
    return FutureBuilder<List<Order>>(
      future: _getFilteredOrders(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator();
        } else if (snapshot.hasError) {
          return const Center(child: Text('Đã xảy ra lỗi.'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'Không có đơn hàng nào',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        } else {
          return _buildOrderList(snapshot.data!);
        }
      },
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: _itemOrder(orders[index], context),
        );
      },
    );
  }

  Widget _itemOrder(Order order, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrdersDetailPage(orderId: order.id), // Pass order.id instead
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.id?.toString() ?? 'Unknown', 
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                'Status: ${order.status}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 5),
              Text(
                'Tổng: ${order.totalPrice?.toStringAsFixed(3) ?? '0.000'} VND',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
