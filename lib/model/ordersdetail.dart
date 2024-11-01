import 'package:sortfood/model/products.dart';

class OrdersDetail {
  int? id;
  int? userId;
  int? orderId;
  String? name;
  DateTime? dateCreated;
  int? cartId; 
  int? quantity;
  List<int>? productIds;
  List<String>? productImages;
  List<double>? productPrices;
  double? totalPrice;
  DateTime? deliveryDate;
  int? cartQuantity;
  List<String> paymentMethod;
  List<String> status;
  List<Products> products;

  OrdersDetail({
    this.id,
    this.userId,
    this.orderId,
    this.name,
    this.dateCreated,
    this.cartId, 
    this.quantity,
    this.productIds = const [],
    this.productImages = const [],
    this.productPrices = const [],
    this.totalPrice,
    this.deliveryDate,
    this.cartQuantity,
    this.paymentMethod = const [], 
    List<String>? status,
    List<Products>? products,
  })  : status = status ?? [],
        products = products ?? [];

  factory OrdersDetail.fromJson(Map<dynamic, dynamic> json) {
    return OrdersDetail(
      id: json['OrderdetailID'] is String 
          ? int.tryParse(json['OrderdetailID']) 
          : json['OrderdetailID'] as int?,
      userId: json['UserI'] is List<dynamic>
          ? (json['UserI'].isNotEmpty ? int.tryParse(json['UserI'][0].toString()) : null)
          : int.tryParse(json['UserI']?.toString() ?? '0'),
      orderId: json['Order'] is int ? json['Order'] : null,
      name: json['UserName'] is List<dynamic> 
          ? (json['UserName'].isNotEmpty ? json['UserName'][0].toString() : null)
          : json['UserName'] as String?,
      dateCreated: json['DateCreated'] is List<dynamic> 
          ? (json['DateCreated'].isNotEmpty ? DateTime.tryParse(json['DateCreated'][0].toString()) : null)
          : DateTime.tryParse(json['DateCreated'] as String? ?? ''),
      cartId: json['CartID'] is List && json['CartID'].isNotEmpty 
          ? int.tryParse(json['CartID'][0].toString()) 
          : json['CartID'] as int?,
      quantity: json['ProductsQuantity'] is int
          ? json['ProductsQuantity']
          : int.tryParse(json['ProductsQuantity']?.toString() ?? '0') ?? 0,
      productIds: (json['ProductIDs'] as List<dynamic>?)
          ?.map((e) => int.tryParse(e.toString()) ?? 0)
          .toList(),
      productImages: (json['Image'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      productPrices: (json['ProductsPrice'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      totalPrice: (json['TotalPrice'] is List ? double.tryParse(json['TotalPrice'][0].toString()) : (json['TotalPrice'] as num?)?.toDouble()),
      deliveryDate: json['DeliveryDate'] is List<dynamic> 
          ? (json['DeliveryDate'].isNotEmpty ? DateTime.tryParse(json['DeliveryDate'][0].toString()) : null)
          : DateTime.tryParse(json['DeliveryDate'] as String? ?? ''),
      paymentMethod: (json['PaymentMethod'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      status: (json['Status'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      products: (json['Products'] as List<dynamic>?)
          ?.map((e) => Products.fromJson(e))
          .toList() ?? [],
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
      'ProductsQuantity': quantity,
      'ProductIDs': productIds,
      'Image': productImages,
      'ProductsPrice': productPrices,
      'TotalPrice': totalPrice,
      'DeliveryDate': deliveryDate?.toIso8601String(),
      'PaymentMethod': paymentMethod,
      'Status': status,
      'Products': products.map((p) => p.toJson()).toList(),
    };
  }
}
