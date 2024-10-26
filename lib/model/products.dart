class Products {
  int? id;
  String? name;
  String? description;
  double price;
  int quantity;
  String img;
  String category;
  List<String> state;

  Products({
    this.id,
    this.name = 'Chưa có tên',
    this.description = 'Chưa có mô tả',
    this.price = 0.000,
    this.quantity = 0,
    this.img = '',
    this.category = 'Chưa có danh mục',
    List<String>? state,
  }) : state = state ?? [];

  factory Products.fromJson(Map<dynamic, dynamic> json) {
    return Products(
      id: (json['ID'] is int) ? json['ID'] : null,
      name: json['Foodname'] ?? 'Chưa có tên',
      description: json['Description'] ?? 'Chưa có mô tả',
      price: (json['Price'] is num) ? json['Price'].toDouble() : 0.000,
      quantity: (json['Quantity'] is int) 
          ? json['Quantity'] 
          : int.tryParse(json['Quantity']?.toString() ?? '0') ?? 0,
      img: (json['Image'] is List && (json['Image'] as List).isNotEmpty)
          ? json['Image'][0]['url'] ?? ''
          : '',
      category: json['Category'] ?? 'Chưa có danh mục',
      state: (json['State'] is List<dynamic>)
          ? (json['State'] as List).map((e) => e.toString()).toList()
          : [],
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'ID': id,
      'Foodname': name,
      'Description': description,
      'Price': price,
      'Quantity': quantity,
      'Image': [
        {'url': img}
      ],
      'Category': category,
      'State': state,
    };
  }

  @override
  String toString() {
    return 'Products(id: $id, name: $name, price: $price, quantity: $quantity, category: $category)';
  }
}
