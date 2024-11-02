import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sortfood/model/ordershistory.dart';
import 'package:sortfood/api/airtableservice.dart';
import 'package:sortfood/ui/order_detail_history.dart';

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
    } catch (e) {
      logger.e('Failed to fetch orders history: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch order history')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lịch sử đơn hàng',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Container(
        color: Colors.orange[50], 
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : orderHistory.isEmpty
                ? const Center(child: Text('Chưa có lịch sử đơn hàng.'))
                : RefreshIndicator(
                    onRefresh: fetchOrderHistory,
                    child: ListView.builder(
                      itemCount: orderHistory.length,
                      itemBuilder: (context, index) {
                        final order = orderHistory[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: _itemHistory(order),
                        );
                      },
                    ),
                  ),
      ),
    );
  }

  Widget _itemHistory(OrdersHistory order) {
      String displayOrderId = order.orderId.isNotEmpty ? order.orderId[0].toString() : 'No Order ID';

      Icon orderStatusIcon;
      if (order.totalPrice != null && order.totalPrice! > 0) {
        orderStatusIcon = const Icon(Icons.check_circle, color: Colors.green);
      } else {
        orderStatusIcon = const Icon(Icons.cancel, color: Colors.red);
      }

      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrdersDetailHistoryPage(orderdetailID: order.orderdetailID, orderHistoryID: order.orderHistoryID)
            ),
          );
        },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: orderStatusIcon,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayOrderId,
                        style: const TextStyle(
                          fontSize: 22,
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
}
