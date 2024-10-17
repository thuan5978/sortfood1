import 'package:flutter/material.dart';
import 'package:sortfood/model/orders.dart';
import 'package:logger/logger.dart';
import 'package:sortfood/api/airtableservice.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  List<Order> orderHistory = [];
  bool isLoading = true;
  final Logger logger = Logger();
  @override
  void initState() {
    super.initState();
    fetchOrderHistory();
  }

  Future<void> fetchOrderHistory() async {
    try {
      AirtableService airtableService = AirtableService();
      List<Order> orders = await airtableService.fetchOrders();
      setState(() {
        orderHistory = orders;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      logger.i('Failed to fetch orders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lịch sử đơn hàng', style: TextStyle(color: Colors.white),)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orderHistory.length,
              itemBuilder: (context, index) {
                final order = orderHistory[index];
                return ListTile(
                  title: Text(order.foodName ?? 'Unknown Food'),
                  subtitle: Text('Số lượng: ${order.quantity} - Giá: ${order.price}'),
                  trailing: Text(order.status ?? 'Unknown Status'),
                );
              },
            ),
    );
  }
}
