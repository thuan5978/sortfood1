class Products {
  String? id;
  String? name;
  String? description;
  double? price;
  int? quantity;
  String? img;
  String? category;
  List<String>? state; 

  Products({
    this.id,
    this.name,
    this.description,
    this.price,
    this.quantity,
    this.img,
    this.category,
    this.state,
  });

  factory Products.fromJson(Map<dynamic, dynamic> json) {
    return Products(
      id: json['ID'],
      name: json['fields']['Foodname'] ?? 'No Name',
      description: json['fields']['Description'] ?? 'No Description',
      price: (json['fields']['Price'] is num) ? json['fields']['Price'].toDouble() : 0.000,
      quantity: json['fields']['Quantity'] ?? 0,
      img: json['fields']['Image'] ?? '',
      category: json['fields']['Category'] ?? 'Uncategorized',
      state: (json['fields']['State'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [], 
    );
  }
}

