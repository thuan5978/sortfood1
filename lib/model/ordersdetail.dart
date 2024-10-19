class OrdersDetail {
  int? id;
  int? userID;
  String? name; 
  DateTime? dateCreated;
  int? cartID;
  int? quantity;
  double? totalPrice;
  double? productPrice; 
  int? productID;
  DateTime? deliveryDate; 
  String? paymentMethod;  
  List<String> status;

  OrdersDetail({
    this.id,
    this.userID,
    this.name,
    this.dateCreated,
    this.cartID,
    this.quantity,
    this.totalPrice,
    this.productPrice,
    this.productID,
    this.deliveryDate,
    this.paymentMethod,
    List<String>? status,
  }) : status = status ?? [];

  factory OrdersDetail.fromJson(Map<dynamic, dynamic> json) {
    return OrdersDetail(
      id: (json['ID'] is int) ? json['ID'] : null,
      userID: (json['UserID'] is int) ? json['UserID'] : null,
      name: json['Name'], 
      dateCreated: json['DateCreated'] != null 
          ? DateTime.tryParse(json['DateCreated']) 
          : null, 
      cartID: (json['CartID'] is int) ? json['CartID'] : null,
      quantity: (json['Quantity'] is int) 
          ? json['Quantity'] 
          : int.tryParse(json['Quantity']?.toString() ?? '0') ?? 0,
      totalPrice: (json['TotalPrice'] is num) ? json['TotalPrice'].toDouble() : 0.000,
      productPrice: (json['ProductPrice'] is num) ? json['ProductPrice'].toDouble() : 0.000, 
      productID: (json['ProductID'] is int) ? json['ProductID'] : null, 
      deliveryDate: json['DeliveryDate'] != null 
          ? DateTime.tryParse(json['DeliveryDate']) 
          : null, 
      paymentMethod: json['PaymentMethod'], 
      status: (json['Status'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
