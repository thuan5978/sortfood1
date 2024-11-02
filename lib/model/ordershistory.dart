class OrdersHistory {
  int? orderHistoryID;
  int? userID;
  List<int?> orderId; 
  int? orderdetailID;
  String? userName;
  String? userAddress;
  DateTime? dateCreated;
  List<int?> cartID;
  List<int?>? quantity;
  double? totalPrice;
  DateTime? deliveryDate;
  List<String> paymentMethod;
  List<String> status;
  List<int?> productID;
  List<double?> productPrice; 

  OrdersHistory({
    this.orderHistoryID,
    this.userID,
    this.orderdetailID,
    this.orderId = const [],
    this.userName,
    this.userAddress,
    this.dateCreated,
    this.cartID = const [],
    this.quantity,
    this.totalPrice,
    this.deliveryDate,
    List<String>? paymentMethod,
    List<String>? status,
    this.productID = const [],
    this.productPrice = const [],
  })  : paymentMethod = paymentMethod ?? [],
        status = status ?? [];

  factory OrdersHistory.fromJson(Map<dynamic, dynamic> json) {
   return OrdersHistory(
      orderHistoryID: json['OrderHistoryID'] as int?,
      userID: json['UserID'] is List<dynamic>
          ? (json['UserID'].isNotEmpty ? int.tryParse(json['UserID'][0].toString()) : null)
          : int.tryParse(json['UserID']?.toString() ?? '0'),
      orderdetailID: json['OrderdetailI'] is List<dynamic>
          ? (json['OrderdetailI'].isNotEmpty ? int.tryParse(json['OrderdetailI'][0].toString()) : null)
          : int.tryParse(json['OrderdetailI']?.toString() ?? '0'),
      orderId: (json['OrderI'] as List<dynamic>?)?.map((e) => int.tryParse(e.toString())).toList() ?? [],
      userName: (json['UserName'] is List<dynamic> && json['UserName'].isNotEmpty)
          ? json['UserName'][0] as String?
          : 'No Name',
      userAddress: (json['UserAddress'] is List<dynamic> && json['UserAddress'].isNotEmpty)
          ? json['UserAddress'][0] as String?
          : 'No Address',
      dateCreated: (json['DateCreated'] is List<dynamic> && json['DateCreated'].isNotEmpty)
          ? DateTime.tryParse(json['DateCreated'][0])
          : null,
      cartID: (json['CartI'] as List<dynamic>?)?.map((e) => int.tryParse(e.toString())).toList() ?? [],
      quantity: (json['CartQuantity'] as List<dynamic>?)?.map((e) => int.tryParse(e.toString())).toList(),
      totalPrice: json['TotalPrice'] is List<dynamic>
          ? (json['TotalPrice'].isNotEmpty ? (json['TotalPrice'][0] as num).toDouble() : 0.0)
          : (json['TotalPrice'] as num?)?.toDouble(),
      deliveryDate: (json['DeliveryDate'] is List<dynamic> && json['DeliveryDate'].isNotEmpty)
          ? DateTime.tryParse(json['DeliveryDate'][0])
          : null,
      paymentMethod: (json['PaymentMethod'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      productID: (json['ProductIDs'] as List<dynamic>?)?.map((e) => int.tryParse(e.toString())).toList() ?? [],
      productPrice: (json['ProductPrice'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList() ?? [],
      status: (json['Status'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
