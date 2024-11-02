import 'package:flutter/material.dart';
import 'package:sortfood/model/ordersdetail.dart';
import 'package:sortfood/api/airtableservice.dart';
import 'package:logger/logger.dart';

class OrdersDetailHistoryPage extends StatefulWidget {
  final int? orderdetailID;
  final int? orderHistoryID; 
  const OrdersDetailHistoryPage({super.key, required this.orderdetailID, required this.orderHistoryID});

  @override
  OrdersDetailHistoryPageState createState() => OrdersDetailHistoryPageState();
}

class OrdersDetailHistoryPageState extends State<OrdersDetailHistoryPage> {
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
      final orderdetailID = widget.orderdetailID;
      final orderhistoryID = widget.orderHistoryID;

      if (orderdetailID != null && orderhistoryID != null) {
        orderDetail = await airtableService.fetchOrdersDetailHistoryById(orderdetailID, orderhistoryID); 
        logger.i('Fetched Order Detail: ${orderDetail.toString()}'); 

        if (orderDetail == null) {
          logger.w('Order not found or products are empty: orderdetailID=$orderdetailID, orderHistoryID=$orderhistoryID');
        } else {
          logger.i('Order detail fetched: ${orderDetail!.id}'); 
        }
      } else {
        logger.e('Order ID or History ID is null'); 
      }
    } catch (e) {
      logger.e('Error fetching order detail for IDs: orderdetailID=${widget.orderdetailID}, orderHistoryID=${widget.orderHistoryID}: $e'); 
      ScaffoldMessenger.of(context).showSnackBar(const
        SnackBar(content: Text('Lỗi khi tải chi tiết đơn hàng. Vui lòng thử lại.')), 
      );
    } finally {
      setState(() {
        isLoading = false; 
      });
    }
  }

  Widget _buildProductSection() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (orderDetail?.productIds != null && orderDetail!.productIds!.isNotEmpty) { 
      return _buildProductList(orderDetail!); 
    } else {
      return const Center(child: Text('Giỏ hàng trống', style: TextStyle(fontSize: 16, color: Colors.grey))); 
    }
  }

  Widget _buildProductList(OrdersDetail orderDetail) {
    final productIds = orderDetail.productIds ?? [];
    final productImages = orderDetail.productImages ?? [];
    final productPrices = orderDetail.productPrices ?? [];
    final productNames = orderDetail.productName ?? [];
    final productQuantities = orderDetail.productquantity; 

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: productIds.length,
      itemBuilder: (context, index) {
        final productId = productIds[index];
        final productImage = index < productImages.length ? productImages[index] : '';
        final productPrice = index < productPrices.length ? productPrices[index] : 0.0;
        final productName = index < productNames.length ? productNames[index] : '';
        final productQuantity = (productQuantities != null && index < productQuantities.length) ? productQuantities[index] : 0; 

        return Padding(
          padding: const EdgeInsets.all(10),
          child: _itemProduct(productId, productName, productImage, productPrice, productQuantity, index),
        );
      },
    );
  }

  Widget _itemProduct(int productId, String productName, String productImage, double productPrice, int productQuantity, int index) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, offset: const Offset(0, 2)),
        ],
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
                productImage,
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
                  productName, 
                  style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  "${productPrice.toStringAsFixed(3)} VND",
                  style: const TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text('Quantity: $productQuantity', style: const TextStyle(fontSize: 18)), 
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
        title: const Text('Chi tiết đơn hàng', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView( 
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
              ],
            ],
          ),
        ),
      ),
    );
  }
}
