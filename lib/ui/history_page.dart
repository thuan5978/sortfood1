import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sortfood/model/ordershistory.dart';
import 'package:sortfood/api/airtableservice.dart';
import 'package:sortfood/ui/order_detail_page.dart'; 

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  List<OrdersHistory> orderHistory = [];
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
      orderHistory = await airtableService.fetchOrdersHistory();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      logger.e('Failed to fetch orders history: $e');
      setState(() {
        isLoading = false;
      });
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử đơn hàng'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orderHistory.isEmpty
              ? const Center(child: Text('Chưa có lịch sử đơn hàng.'))
              : ListView.builder(
                  itemCount: orderHistory.length,
                  itemBuilder: (context, index) {
                    final order = orderHistory[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: _itemHistory(order),
                    );
                  },
                ),
    );
  }

  Widget _itemHistory(OrdersHistory order) {
    String displayOrderId = (order.orderId.isNotEmpty && order.orderId[0] != null)
        ? order.orderId[0]!
        : 'No Order ID';

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrdersDetailPage(orderId: order.orderdetailID),
          ),
        );
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayOrderId,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ngày: ${order.dateCreated?.toLocal().toString().split(' ')[0] ?? 'N/A'}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 5),
              Text(
                'Tổng: ${order.totalPrice?.toStringAsFixed(3) ?? '0.000'} VND',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              Divider(thickness: 1.5, color: Colors.grey[300]),
              const SizedBox(height: 10),
              Text(
                'Chi tiết: ${order.orderdetailID ?? 'N/A'}',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
