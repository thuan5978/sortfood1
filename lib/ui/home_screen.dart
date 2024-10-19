import 'dart:math';

import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sortfood/api/airtableservice.dart';
import 'package:sortfood/model/products.dart';
import 'package:sortfood/ui/cart_page.dart';
import 'package:logger/logger.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  final AirtableService airtableService = AirtableService();
  final Logger logger = Logger();
  
  
  List<Products> cartProducts = [];
  List<Products> searchResults = [];
  List<String> categories = ['Tất cả', 'Món chính', 'Đồ uống', 'Tráng miệng', 'Trà sữa'];
  String selectedCategory = 'Tất cả';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    searchProducts();
  }

  void searchProducts() async {
  if (!mounted) return; // Check if the widget is still mounted before setting the loading state.
  
  setState(() {
    isLoading = true;
  });

  String query = searchController.text;
    List<Products> results = [];

    try {
      if (query.isNotEmpty) {
        results = await airtableService.searchProducts(query);
      } else {
        results = await airtableService.fetchProducts();
      }

      if (selectedCategory != 'Tất cả') {
        results = results.where((product) => product.category == selectedCategory).toList();
      }

      logger.i(results);

    } catch (error) {
      logger.e("Error fetching products: $error");
    } finally {
      if (!mounted) return; // Check if the widget is still mounted before updating the state.
      
      setState(() {
        searchResults = results;
        isLoading = false;
      });
    }
  }


  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
    searchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
        title: const Text('Trang chủ', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cartProducts: cartProducts),
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm sản phẩm...',
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(8.0),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search, color: Colors.orange),
                      onPressed: searchProducts,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              flex: 0,
              child: _buildCategoryChips(),
            ),
            const SizedBox(height: 20),
            _buildProductSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 50.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(5.0),
            child: ChoiceChip(
              label: Text(categories[index], style: const TextStyle(color: Colors.white)),
              selected: selectedCategory == categories[index],
              backgroundColor: Colors.orange,
              selectedColor: Colors.deepOrange,
              onSelected: (bool selected) {
                onCategorySelected(categories[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductSection() {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : searchResults.isNotEmpty
            ? _buildProductList(searchResults)
            : const Center(child: Text('Không tìm thấy sản phẩm', style: TextStyle(fontSize: 16, color: Colors.grey)));
  }

  Widget _buildProductList(List<Products> products) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Padding(
          padding: const EdgeInsets.all(10),
          child: _itemProduct(product),
        );
        // ListTile(
        //   leading: product.img != null && product.img!.isNotEmpty
        //       ? Image.network(
        //           product.img!,
        //           width: 50.0,
        //           height: 50.0,
        //           fit: BoxFit.cover,
        //           errorBuilder: (context, error, stackTrace) {
        //             return const Icon(Icons.error);
        //           },
        //         )
        //       : const Icon(Icons.image_not_supported),
        //   title: Text(product.name ?? 'No Name'),
        //   subtitle: Text('${product.price?.toStringAsFixed(3) ?? '0.000'} VND'),
        //   trailing: IconButton(
        //     icon: const Icon(Icons.add_shopping_cart, color: Colors.orange),
        //     onPressed: () {
        //       addToCart(product); 
        //     },
        //   ),
        // );
      },
    );
  }

  Widget _itemProduct(Products product){
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //image
          SizedBox(
            width: 120,
            height: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(product.img, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),),
            )
          ),
          const SizedBox(width: 20,),

          //title
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(product.name!, style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 2,),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text("${product.price.toStringAsFixed(3)} VND", style: const TextStyle(color: Colors.orange, fontSize: 17, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 2,),
                    ),
                  ],
                ),
                const SizedBox(height: 40,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: (){

                      }, 
                      icon: const Icon(Icons.shopping_bag, color: Colors.blue, size: 30,)
                    ),

                    IconButton(
                      onPressed: (){

                      }, 
                      icon: const Icon(CupertinoIcons.heart_fill, color: Colors.red, size: 30,)
                    )
                  ],
                )
              ],
            )
          ),

          //action
          IconButton(
            onPressed: (){

            }, 
            icon: const Icon(Icons.menu, color: Colors.grey, size: 30,)
          )
        ],
      ),
    );
  }

  
  void addToCart(Products product) {
    setState(() {
      cartProducts.add(product); 
    });
    logger.i('Added to cart: ${product.name}');
  }
}
