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
  List<Products> searchResults = [];
  List<String> categories = ['Tất cả', 'Món chính', 'Đồ uống', 'Tráng miệng'];
  String selectedCategory = 'Tất cả';
  bool isLoading = true; 

  @override
  void initState() {
    super.initState();
    searchProducts(); 
  }

  void searchProducts() async {
    setState(() {
      isLoading = true; 
    });

    String query = searchController.text;
    List<Products> results = [];
    
    if (query.isNotEmpty) {
      results = await airtableService.searchProducts(query);
    } else {
      results = await airtableService.fetchProducts();
    }

    if (selectedCategory != 'Tất cả') {
      results = results.where((product) => product.category == selectedCategory).toList();
    }

    logger.i(results); 

    setState(() {
      searchResults = results;
      isLoading = false; 
    });
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
        backgroundColor: Colors.orange,
        title: const Text('Trang chủ', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
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
            _body(context),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
          ),
          const SizedBox(height: 20.0),

          
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : searchResults.isNotEmpty
                  ? _buildProductList(searchResults)
                  : const Center(child: Text('Không tìm thấy sản phẩm')), 
        ],
      ),
    );
  }

  Widget _buildProductList(List<Products> products) {
    return ListView.builder(
      shrinkWrap: true, 
      physics: const NeverScrollableScrollPhysics(), 
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ListTile(
          leading: product.img != null && product.img!.isNotEmpty
              ? Image.network(
                  product.img!,
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                )
              : const Icon(Icons.image_not_supported),
          title: Text(product.name ?? 'No Name'),
          subtitle: Text(product.price?.toStringAsFixed(3) ?? '0.000'),
        );
      },
    );
  }
}
