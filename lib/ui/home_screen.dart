import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sortfood/api/airtableservice.dart';
import 'package:sortfood/model/products.dart';
import 'package:sortfood/ui/cart_page.dart';
import 'package:logger/logger.dart';
import 'package:sortfood/provider/user_provider.dart';
import 'package:sortfood/model/usermodel.dart';
import 'package:sortfood/model/users.dart';


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
    _initializeUserData();
    searchProducts();
  }

  Future<void> _initializeUserData() async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final users = await airtableService.fetchUsers(); 

  if (users.isNotEmpty) {
    
    final userModel = convertUsersToUserModel(users[0]); 
    await userProvider.setCurrentUser(userModel); 
  }
}

  UserModel convertUsersToUserModel(Users user) {
    return UserModel(
      userId: user.userId ?? 0, 
      userName: user.userName ?? 'No Name',
      email: user.email ?? 'No email',
      phone: user.phone ?? 'No phone',
      img: user.img ?? '',
      address: user.address ?? 'No location',
      password: user.password, 
    );
  }

  void searchProducts() async {
    if (!mounted) return;

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
      logger.e("Lỗi khi lấy sản phẩm: $error");
    } finally {
      if (mounted) {
        setState(() {
          searchResults = results;
          isLoading = false;
        });
      }
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
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser; 

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
        title: const Text('Trang chủ', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              if (currentUser != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(
                      cartProducts: cartProducts,
                      userId: currentUser.userId ,
                      userName: currentUser.userName ,
                      address: currentUser.address ,
                      paymentMethod: 'Phương thức thanh toán',
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vui lòng đăng nhập để xem giỏ hàng.')),
                );
              }
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
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildCategoryChips(),
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
      },
    );
  }

  Widget _itemProduct(Products product) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                product.img,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name!,
                  style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  "${product.price.toStringAsFixed(3)} VND",
                  style: const TextStyle(color: Colors.orange, fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => addToCart(product), 
                      icon: const Icon(Icons.shopping_bag, color: Colors.blue, size: 30),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite, color: Colors.red, size: 30),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, color: Colors.grey, size: 30),
          ),
        ],
      ),
    );
  }

  void addToCart(Products product) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.currentUser; // Get the current user

    if (currentUser != null) {
      setState(() {
        cartProducts.add(product);
      });
      logger.i('Đã thêm vào giỏ hàng: ${product.name}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.name} đã được thêm vào giỏ hàng!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng.')),
      );
    }
  }
}
