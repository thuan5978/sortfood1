class OrdersHistory {
  int? id;
  int? userID;
  String? userName; 
  DateTime? dateCreated; 
  int? cartID;
  int? quantity;
  double? totalPrice;
  DateTime? deliveryDate; 
  String? paymentMethod;  
  List<String> status; 
  int? productID; 
  double? productPrice;

  OrdersHistory({
    this.id,
    this.userID,
    this.userName,
    this.dateCreated,
    this.cartID,
    this.quantity,
    this.totalPrice,
    this.deliveryDate,
    this.paymentMethod,
    List<String>? status,
    this.productID,
    this.productPrice,
  }) : status = status ?? [];

  factory OrdersHistory.fromJson(Map<dynamic, dynamic> json) {
    return OrdersHistory(
      id: (json['ID'] is int) ? json['ID'] : null,
      userID: (json['UserID'] is int) ? json['UserID'] : null,
      userName: json['UserName'] ?? 'No Name',
      dateCreated: json['DateCreated'] != null 
          ? DateTime.tryParse(json['DateCreated']) 
          : null,
      cartID: (json['CartID'] is int) ? json['CartID'] : null,
      quantity: (json['Quantity'] is int) 
          ? json['Quantity'] 
          : int.tryParse(json['Quantity']?.toString() ?? '0') ?? 0,
      totalPrice: (json['TotalPrice'] is num) ? json['TotalPrice'].toDouble() : 0.0,
      deliveryDate: json['DeliveryDate'] != null 
          ? DateTime.tryParse(json['DeliveryDate']) 
          : null,
      paymentMethod: json['PaymentMethod'],
      productID: (json['ProductID'] is int) ? json['ProductID'] : null,
      productPrice: (json['ProductPrice'] is num) ? json['ProductPrice'].toDouble() : 0.0,
      status: (json['Status'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
