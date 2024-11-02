import 'package:sortfood/model/products.dart';

class OrdersDetail {
  int? id;
  int? userId;
  int? orderId;
  String? name;
  DateTime? dateCreated;
  int? cartId; 
  List<int>? productquantity;
  List<int>? productIds;
  List<String>? productName;
  List<String>? productImages;
  List<double>? productPrices;
  double? totalPrice;
  DateTime? deliveryDate;
  int? cartQuantity;
  List<String> paymentMethod;
  List<String> status;
  List<Products> products;
  int? orderHistoryID;

  OrdersDetail({
    this.id,
    this.userId,
    this.orderId,
    this.name,
    this.dateCreated,
    this.cartId, 
    this.productquantity,
    this.productIds, 
    this.productName,
    this.productImages, 
    this.productPrices, 
    this.totalPrice,
    this.deliveryDate,
    this.cartQuantity,
    this.paymentMethod = const [], 
    List<String>? status,
    List<Products>? products,
    this.orderHistoryID,
  })  : status = status ?? [],
        products = products ?? [];

 factory OrdersDetail.fromJson(Map<dynamic, dynamic> json) {
    return OrdersDetail(
      id: json['OrderdetailID'] is String 
          ? int.tryParse(json['OrderdetailID']) 
          : json['OrderdetailID'] as int?,
      userId: json['UserI'] is List
          ? (json['UserI'].isNotEmpty ? int.tryParse(json['UserI'][0].toString()) : null)
          : int.tryParse(json['UserI']?.toString() ?? '0'),
      orderId: json['Order'] as int?,
      name: json['UserName'] is List 
          ? (json['UserName'].isNotEmpty ? json['UserName'][0].toString() : null)
          : json['UserName'] as String?,
      dateCreated: json['DateCreated'] is List 
          ? (json['DateCreated'].isNotEmpty ? DateTime.tryParse(json['DateCreated'][0].toString()) : null)
          : DateTime.tryParse(json['DateCreated'] as String? ?? ''),
      cartId: json['CartID'] is List && json['CartID'].isNotEmpty 
          ? int.tryParse(json['CartID'][0].toString()) 
          : json['CartID'] as int?,
      productquantity: (json['ProductsQuantity'] as List?)?.map((e) => int.tryParse(e.toString()) ?? 0).toList() ?? [],
      productIds: (json['ProductIDs'] as List?)?.map((e) => int.tryParse(e.toString()) ?? 0).toList() ?? [],
      productName: (json['ProductName'] as List?)?.map((e) => e.toString()).toList() ?? ['Unnamed Product'],
      productImages: (json['ProductImages'] as List?)
     ?.map((e) => e['url'].toString())
      .toList() ?? [],
      productPrices: (json['ProductsPrice'] as List?)?.map((e) => (e as num).toDouble()).toList() ?? [],
      totalPrice: json['TotalPrice'] is List 
          ? double.tryParse(json['TotalPrice'][0].toString()) 
          : (json['TotalPrice'] as num?)?.toDouble(),
      deliveryDate: json['DeliveryDate'] is List 
          ? (json['DeliveryDate'].isNotEmpty ? DateTime.tryParse(json['DeliveryDate'][0].toString()) : null)
          : DateTime.tryParse(json['DeliveryDate'] as String? ?? ''),
      paymentMethod: (json['PaymentMethod'] as List?)?.map((e) => e.toString()).toList() ?? [],
      status: (json['Status'] as List?)?.map((e) => e.toString()).toList() ?? [],
      products: (json['Products'] as List?)?.map((e) => Products.fromJson(e)).toList() ?? [],
      orderHistoryID: int.tryParse(json['OrderHistoryID']?.toString() ?? '0'),
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'OrderdetailID': id,
      'UserID': userId,
      'Order': orderId,
      'UserName': name,
      'DateCreated': dateCreated?.toIso8601String(),
      'CartID': cartId, 
      'ProductsQuantity': productquantity,
      'ProductIDs': productIds,
      'Image': productImages,
      'ProductsPrice': productPrices,
      'TotalPrice': totalPrice,
      'DeliveryDate': deliveryDate?.toIso8601String(),
      'PaymentMethod': paymentMethod,
      'Status': status,
      'Products': products.map((p) => p.toJson()).toList(),
      'OrderHistoryID': orderHistoryID,
    };
  }
}
