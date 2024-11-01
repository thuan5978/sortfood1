class Order {
  int? id;
  int? userId;  
  String? name; 
  String? phone;
  String? address; 
  DateTime? dateCreated;
  int? cartId;
  int? quantity;
  double? totalPrice;
  DateTime? deliveryDate; 
  String? paymentMethod;
  List<String> status;

  Order({
    this.id,
    this.userId,
    this.name,
    this.phone,
    this.address,
    this.dateCreated,
    this.cartId,
    this.quantity,
    this.totalPrice,
    this.deliveryDate,
    this.paymentMethod,
    List<String>? status,
  }) : status = status ?? [];

  factory Order.fromJson(Map<dynamic, dynamic> json) {
    return Order(
      id: json['ID'] as int?,
      userId: json['UserI'] is List
          ? (json['UserI'].isNotEmpty ? int.tryParse(json['UserI'][0].toString()) : null)
          : int.tryParse(json['UserI']?.toString() ?? '0'),
      name: json['UserName'] is List 
          ? (json['UserName'].isNotEmpty ? json['UserName'][0].toString() : null)
          : json['UserName'] as String?,
      phone: json['UserPhone'] is List
          ? (json['UserPhone'].isNotEmpty ? json['UserPhone'][0].toString() : null)
          : json['UserPhone'] as String?,
      address: json['UserAddress'] is List 
          ? (json['UserAddress'].isNotEmpty ? json['UserAddress'][0].toString() : null)
          : json['UserAddress'] as String?,
      dateCreated: json['DateCreated'] is String 
          ? DateTime.tryParse(json['DateCreated']) 
          : null,
      cartId: json['CartID'] is List
          ? (json['CartID'].isNotEmpty ? int.tryParse(json['CartID'][0].toString()) : null)
          : json['CartID'] as int?,
      quantity: json['CartQuantity'] is List
          ? (json['CartQuantity'].isNotEmpty ? int.tryParse(json['CartQuantity'][0].toString()) : null)
          : json['CartQuantity'] as int? ?? 0,
      totalPrice: json['CartTotalPrice'] is List
          ? (json['CartTotalPrice'].isNotEmpty ? double.tryParse(json['CartTotalPrice'][0].toString()) : 0.0)
          : (json['CartTotalPrice'] as num?)?.toDouble() ?? 0.0,
      deliveryDate: json['DeliveryDate'] is String 
          ? DateTime.tryParse(json['DeliveryDate']) 
          : null,
      paymentMethod: json['PaymentMethod'] as String?,
      status: json['Status'] is List
          ? (json['Status'] as List<dynamic>).map((e) => e.toString()).toList()
          : (json['Status'] is String ? [json['Status']] : []),
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'ID': id,
      'UserID': userId, 
      'UserName': name,
      'UserPhone': phone,
      'UserAddress': address,
      'DateCreated': dateCreated?.toIso8601String(),
      'CartID': cartId,
      'CartQuantity': quantity,
      'TotalPrice': totalPrice,
      'DeliveryDate': deliveryDate?.toIso8601String(),
      'PaymentMethod': paymentMethod,
      'Status': status,
    };
  }
}
