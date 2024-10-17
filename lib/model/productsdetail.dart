class Productsdetail {
  String? id;
  String? name;
  String? ingredient;

  Productsdetail({
    this.id,
    this.name,
    this.ingredient,
  });

  factory Productsdetail.fromJson(Map<dynamic,dynamic> json){
    return Productsdetail(
        id: json['ID'],
        name: json['fields']['Foodname'] ?? 'No Name',
        ingredient: json['fields']['ingredient'] ?? 'No ingredient',
    );
  }
}