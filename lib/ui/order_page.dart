import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sortfood/model/orders.dart';
import 'package:sortfood/provider/user_provider.dart';
import 'package:sortfood/api/airtableservice.dart';

class OrderPage extends StatefulWidget {
  final bool isLoading;

  const OrderPage({super.key, this.isLoading = false});

  @override
  OrderPageState createState() => OrderPageState();
}

class OrderPageState extends State<OrderPage> {
  final Logger logger = Logger();

  Future<List<Order>> _getFilteredOrders(BuildContext context) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final currentUserId = userProvider.currentUserId;
  final AirtableService airtableService = AirtableService();
  
    try {
      final orders = await airtableService.fetchOrders();
      logger.i('Fetched Orders: ${orders.map((e) => e.toJson()).toList()}');
      
      final int currentUserIdInt = int.tryParse(currentUserId.toString()) ?? -1;

      final filteredOrders = orders.where((order) {
        final isUserMatch = order.userId != null && 
                            order.userId!.contains(currentUserIdInt);
        
        final hasPendingStatus = order.status.contains('Pending'); 

        return isUserMatch && hasPendingStatus;
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Đơn hàng #${order.id}',
            style: const TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Tổng số sản phẩm: ${order.quantity}',
              style: const TextStyle(color: Colors.black, fontSize: 16)),
          Text(
            'Tổng số tiền: ${order.totalPrice?.toStringAsFixed(3)} VND',
            style: const TextStyle(color: Colors.orange, fontSize: 16),
          ),
          Text('Địa chỉ giao hàng: ${order.address}',
              style: const TextStyle(color: Colors.black, fontSize: 16)),
          Text(
            'Ngày tạo: ${order.dateCreated?.toLocal().toString().split(' ')[0] ?? 'N/A'}',
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          Text(
            'Ngày giao: ${order.deliveryDate?.toLocal().toString().split(' ')[0] ?? 'N/A'}',
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
