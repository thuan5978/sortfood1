class Order {
  int? id;
  List<int>? userId;
  String? name; 
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
    id: json['ID'] is int ? json['ID'] : null,
    userId: (json['UserID'] is List<dynamic>) 
      ? (json['UserID'] as List<dynamic>).map((e) => int.tryParse(e.toString()) ?? 0).toList() 
      : (json['UserID'] is String ? [int.tryParse(json['UserID']!) ?? 0] : []),
    name: json['Name'] as String?,
    address: json['Address'] as String?,
    dateCreated: json['DateCreated'] != null 
        ? DateTime.tryParse(json['DateCreated'] as String) 
        : null,
    cartId: json['CartID'] is int ? json['CartID'] : null,
    quantity: json['Quantity'] is int 
        ? json['Quantity'] 
        : int.tryParse(json['Quantity']?.toString() ?? '0') ?? 0,
    totalPrice: json['TotalPrice'] is num ? (json['TotalPrice'] as num).toDouble() : 0.0,
    deliveryDate: json['DeliveryDate'] != null 
        ? DateTime.tryParse(json['DeliveryDate'] as String) 
        : null,
    paymentMethod: json['PaymentMethod'] as String?,
    status: (json['Status'] is List<dynamic>) 
      ? (json['Status'] as List<dynamic>).map((e) => e as String).toList() 
      : (json['Status'] is String ? [json['Status']] : []),
  );
}

  Map<dynamic, dynamic> toJson() {
  return {
    'ID': id,
    'UserID': userId,
    'Name': name,
    'Address': address,
    'DateCreated': dateCreated?.toIso8601String(),
    'CartID': cartId,
    'Quantity': quantity,
    'TotalPrice': totalPrice,
    'DeliveryDate': deliveryDate?.toIso8601String(),
    'PaymentMethod': paymentMethod,
    'Status': status,
  };
}

}
