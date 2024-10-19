import 'package:flutter/material.dart';
import 'package:sortfood/model/ordershistory.dart';
import 'package:logger/logger.dart';
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
      List<OrdersHistory> orders = await airtableService.fetchOrdersHistory();
      setState(() {
        orderHistory = orders;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      logger.i('Failed to fetch orders history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Lịch sử đơn hàng', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Container(
            width: width,
            height: height,
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: orderHistory.length,
              itemBuilder: (context, index) {
                final order = orderHistory[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(order.userName ?? 'Unknown User',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      'Số lượng: ${order.quantity} - Tổng giá: ${(order.totalPrice ?? 0.000).toStringAsFixed(3)} VND',
                    ),
                    trailing: Text(order.status.isNotEmpty
                        ? order.status.join(", ")
                        : 'Unknown Status'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OrdersDetailPage(orderId: order.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
  }
}