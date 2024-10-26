import 'package:sortfood/model/products.dart';

class OrdersDetail {
  int? id;
  List<int>? userId;
  String? name;
  DateTime? dateCreated;
  List<int>? cartId;
  int? quantity;
  List<int>? productIds;
  List<String>? productImages;
  List<int>? productPrices;
  double? totalPrice;
  DateTime? deliveryDate;
  String? paymentMethod;
  List<String> status;
  List<Products> products;

  OrdersDetail({
    this.id,
    this.userId,
    this.name,
    this.dateCreated,
    this.cartId,
    this.quantity,
    this.productIds,
    this.productImages,
    this.productPrices,
    this.totalPrice,
    this.deliveryDate,
    this.paymentMethod,
    List<String>? status,
    List<Products>? products,
  })  : status = status ?? [],
        products = products ?? [];

  factory OrdersDetail.fromJson(Map<dynamic, dynamic> json) {
    return OrdersDetail(
      id: json['OrderdetailID'] is String 
          ? int.tryParse(json['OrderdetailID']) 
          : json['OrderdetailID'] as int?,
      userId: (json['UserID'] as List<dynamic>?)?.map((e) => int.tryParse(e.toString()) ?? 0).toList(),
      name: json['Name'] as String?,
      dateCreated: json['DateCreated'] != null 
          ? DateTime.tryParse(json['DateCreated']) 
          : null,
      cartId: (json['CartID'] as List<dynamic>?)?.map((e) => int.tryParse(e.toString()) ?? 0).toList(),
      quantity: json['Quantity'] as int?,
      productIds: (json['ProductIDs'] as List<dynamic>?)?.map((e) => int.tryParse(e.toString()) ?? 0).toList(),
      productImages: (json['ProductImages'] as List<dynamic>?)?.map((e) => e as String).toList(),
      productPrices: (json['Price (from Products) (from CartID)'] as List<dynamic>?)?.map((e) => int.tryParse(e.toString()) ?? 0).toList(),
      totalPrice: (json['TotalPrice'] as num?)?.toDouble(),
      deliveryDate: json['DeliveryDate'] != null 
          ? DateTime.tryParse(json['DeliveryDate']) 
          : null,
      paymentMethod: json['PaymentMethod'] as String?,
      status: (json['Status'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      products: (json['Products'] as List<dynamic>?)?.map((e) => Products.fromJson(e)).toList() ?? [],
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'OrderdetailID': id,
      'UserID': userId,
      'Name': name,
      'DateCreated': dateCreated?.toIso8601String(),
      'CartID': cartId,
      'Quantity': quantity,
      'ProductIDs': productIds,
      'ProductImages': productImages,
      'Price (from Products) (from CartID)': productPrices,
      'TotalPrice': totalPrice,
      'DeliveryDate': deliveryDate?.toIso8601String(),
      'PaymentMethod': paymentMethod,
      'Status': status,
      'Products': products.map((p) => p.toJson()).toList(),
    };
  }
}
