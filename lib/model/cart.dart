import 'package:sortfood/model/products.dart';

class Cart {
  int? id;
  int? userID;
  List<int>? productsIDs;
  List<double>? productPrices;
  String? img;
  int? quantity;
  double? totalPrice;
  List<Products>? cartProducts;

  Cart({
    this.id,
    this.userID,
    this.productsIDs,
    this.productPrices,
    this.img,
    this.quantity,
    this.totalPrice,
    this.cartProducts,
  });

  factory Cart.fromJson(Map<dynamic, dynamic> json) {
    return Cart(
      id: (json['ID'] is int) ? json['ID'] : null,
      userID: (json['UserI'] is int) ? json['UserI'] : null,
      productsIDs: (json['ProductIDs'] as List<dynamic>?)?.whereType<int>().toList(),
      productPrices: (json['ProductsPrice'] as List<dynamic>?)?.whereType<num>().map((item) => item.toDouble()).toList(),
      quantity: (json['ProductsQuantity'] is int) ? json['ProductsQuantity'] : null,
      img: (json['Image'] is List && (json['Image'] as List).isNotEmpty)
          ? json['Image'][0]['url'] ?? ''
          : '',
      totalPrice: (json['TotalPrice'] is num) ? json['TotalPrice'].toDouble() : null,
      cartProducts: (json['CartProducts'] as List<dynamic>?) 
          ?.map((item) => Products.fromJson(item)) 
          .toList(),
    );
  }
}
