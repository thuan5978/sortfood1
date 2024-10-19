class Cart {
  int? id;
  int? userID;
  int? userLookupID;
  List<int>? productsIDs;
  List<int>? productLookupIDs;  
  List<double>? productPrices;
  int? quantity;
  double? totalPrice;

  Cart({
    this.id,
    this.userID,
    this.userLookupID,
    this.productsIDs,
    this.productLookupIDs,
    this.productPrices,
    this.quantity,
    this.totalPrice,
  });

  factory Cart.fromJson(Map<dynamic, dynamic> json) {
    return Cart(
      id: (json['ID'] is int) ? json['ID'] : null,
      userID: (json['UserID'] is int) ? json['UserID'] : null,
      userLookupID: (json['UserLookupID'] is int) ? json['UserLookupID'] : null, 
      productsIDs: (json['ProductsID'] as List<dynamic>?)
          ?.whereType<int>() 
          .toList(),
      productLookupIDs: (json['ID (from Products)'] as List<dynamic>?)
          ?.whereType<int>()  
          .toList(),
      productPrices: (json['Price (from Products)'] as List<dynamic>?)
          ?.whereType<num>()  
          .map((item) => item.toDouble())
          .toList(),
      quantity: (json['Quantity'] is int) ? json['Quantity'] : null,
      totalPrice: (json['TotalPrice'] is num) ? json['TotalPrice'].toDouble() : null,
    );
  }
}
