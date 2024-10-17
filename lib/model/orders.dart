class Order {
  String? id;
  String? foodName;
  int? quantity;
  double? price;
  String? status;

  Order({
    this.id,
    this.foodName,
    this.quantity,
    this.price,
    this.status,
  });

  factory Order.fromJson(Map<dynamic, dynamic> json) {
    return Order(
      id: json['id'],
      foodName: json['fields']['FoodName'] ?? 'Unknown',
      quantity: json['fields']['Quantity'] ?? 0,
      price: (json['fields']['Price'] is num) ? json['fields']['Price'].toDouble() : 0.0,
      status: json['fields']['Status'] ?? 'Unknown',
    );
  }
}
