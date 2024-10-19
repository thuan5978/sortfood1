import 'package:flutter/material.dart';
import 'package:sortfood/model/ordersdetail.dart';
import 'package:sortfood/api/airtableservice.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';  // For date formatting

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
    fetchOrderDetail();
  }

  Future<void> fetchOrderDetail() async {
  try {
    AirtableService airtableService = AirtableService();
    List<OrdersDetail> details = await airtableService.fetchOrdersDetail();
    
    setState(() {
      orderDetail = details.firstWhere(
        (detail) => detail.id == widget.orderId,
        orElse: () => OrdersDetail(id: 0, name: 'N/A', quantity: 0, totalPrice: 0.0, dateCreated: DateTime.now(), paymentMethod: 'N/A', status: ['Unknown']), 
      );
      isLoading = false;
    });
  } catch (e) {
    setState(() {
      isLoading = false;
    });
    logger.e('Failed to fetch order details: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Chi tiết đơn hàng', style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orderDetail != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tên: ${orderDetail?.name ?? 'N/A'}',
                            style: const TextStyle(fontSize: 18)),
                        Text('Số lượng: ${orderDetail?.quantity ?? 0}',
                            style: const TextStyle(fontSize: 18)),
                        Text(
                            'Tổng giá: ${(orderDetail?.totalPrice ?? 0.0).toStringAsFixed(3)} VND',
                            style: const TextStyle(fontSize: 18)),
                        Text(
                            'Ngày tạo: ${orderDetail?.dateCreated != null ? DateFormat('dd-MM-yyyy').format(orderDetail!.dateCreated!.toLocal()) : 'N/A'}',
                            style: const TextStyle(fontSize: 18)),
                        Text(
                            'Phương thức thanh toán: ${orderDetail?.paymentMethod ?? 'N/A'}',
                            style: const TextStyle(fontSize: 18)),
                        Text('Trạng thái: ${orderDetail?.status.join(", ")}',
                            style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                )
              : const Center(child: Text('Không tìm thấy chi tiết đơn hàng')),
    );
  }
}
