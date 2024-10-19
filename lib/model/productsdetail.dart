class ProductsDetail {
  int? id;          
  String? name;     
  String? ingredient;

  ProductsDetail({
    this.id,
    this.name = 'No Name', 
    this.ingredient = 'No ingredient',  
  });

  factory ProductsDetail.fromJson(Map<dynamic, dynamic> json) {
    return ProductsDetail(
      id: (json['id'] is int) ? json['id'] : null,
      name: json['Foodname'] ?? 'No Name',
      ingredient: json['ingredient'] ?? 'No ingredient',
    );
  }

  @override
  String toString() {
    return 'ProductsDetail(id: $id, name: $name, ingredient: $ingredient)';
  }
}
