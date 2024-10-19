class Order {
  int? id;
  int? userID;
  String? name; 
  String? address; 
  DateTime? datecreated;
  int? cartID;
  int? quantity;
  double? totalprice;
  DateTime? deliverydate; 
  String? paymentmethod;

  Order({
    this.id,
    this.userID,
    this.name,
    this.address,
    this.datecreated,
    this.cartID,
    this.quantity,
    this.totalprice,
    this.deliverydate,
    this.paymentmethod,
  });

  factory Order.fromJson(Map<dynamic, dynamic> json) {
    return Order(
      id: (json['ID'] is int) ? json['ID'] : null,
      userID: (json['UserID'] is int) ? json['UserID'] : null,
      name: json['Name'], 
      address: json['Address'], 
      datecreated: json['DateCreated'] != null 
          ? DateTime.tryParse(json['DateCreated']) 
          : null,
      cartID: (json['CartID'] is int) ? json['CartID'] : null,
      quantity: (json['Quantity'] is int) 
          ? json['Quantity'] 
          : int.tryParse(json['Quantity']?.toString() ?? '0') ?? 0,
      totalprice: (json['TotalPrice'] is num) ? json['TotalPrice'].toDouble() : 0.0,
      deliverydate: json['DeliveryDate'] != null 
          ? DateTime.tryParse(json['DeliveryDate']) 
          : null,
      paymentmethod: json['PaymentMethod'],
    );
  }
}