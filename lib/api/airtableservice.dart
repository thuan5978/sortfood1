import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:sortfood/model/orders.dart';
import 'package:sortfood/model/products.dart';
import 'package:sortfood/model/users.dart';
import 'package:sortfood/model/ordershistory.dart';
import 'package:sortfood/model/ordersdetail.dart';
import 'package:sortfood/model/cart.dart';
import 'package:sortfood/model/productsdetail.dart';

class AirtableService {
  final String apiKey;
  final String baseId;
  final String usersTableId;
  final String productsTableId;
  final String ordersTableId;
  final String ordersHistoryTableId;
  final String ordersDetailTableId;
  final String cartTableId;
  final String productsDetailTableId;

  final Logger logger = Logger();
  List<Users> _localUsers = [];
  List<Products> _localProducts = [];
  List<Order> _localOrders = [];
  List<OrdersHistory> _localOrdersHistory = [];
  List<OrdersDetail> _localOrdersDetail = [];
  List<Cart> _localCart = [];
  List<ProductsDetail> _localProductsDetail = [];

  AirtableService()
      : apiKey = dotenv.env['API_KEY'] ?? '',
        baseId = dotenv.env['BASE_ID'] ?? '',
        usersTableId = dotenv.env['USERS_ID'] ?? '',
        productsTableId = dotenv.env['PRODUCTS_ID'] ?? '',
        ordersTableId = dotenv.env['ORDERS_ID'] ?? '',
        ordersHistoryTableId = dotenv.env['ORDERS_HISTORY_ID'] ?? '',
        ordersDetailTableId = dotenv.env['ORDERS_DETAIL_ID'] ?? '',
        cartTableId = dotenv.env['CART_ID'] ?? '',
        productsDetailTableId = dotenv.env['PRODUCTS_DETAIL_ID'] ?? '' {
    _checkEnvironmentVariables();
  }

  void _checkEnvironmentVariables() {
    if (apiKey.isEmpty || baseId.isEmpty || 
        usersTableId.isEmpty || productsTableId.isEmpty || 
        ordersTableId.isEmpty || ordersHistoryTableId.isEmpty || 
        ordersDetailTableId.isEmpty || cartTableId.isEmpty || 
        productsDetailTableId.isEmpty) {
      logger.w('One or more environment variables are not set. Please check your configuration.');
    }
  }

  Future<List<Users>> fetchUsers() async {
    _localUsers = await _fetchData<Users>(usersTableId, (json) => Users.fromJson(json));
    return _localUsers; 
  }

  Future<List<Products>> fetchProducts() async {
    _localProducts = await _fetchData<Products>(productsTableId, (json) => Products.fromJson(json));
    return _localProducts; 
  }

 
  Future<List<Order>> fetchOrders() async {
    try {
      final rawData = await _fetchData<Order>(
        ordersTableId,
        (json) => Order.fromJson(json),
      );
      logger.i("Raw data from Airtable: $rawData");
      _localOrders = rawData;
      return _localOrders;
    } catch (e) {
      logger.e("Error fetching orders: $e");
      return []; 
    }
  }



  Future<List<OrdersDetail>> fetchOrdersDetail() async {

    _localOrdersDetail = await _fetchData<OrdersDetail>(ordersDetailTableId, (json) => OrdersDetail.fromJson(json));
    return _localOrdersDetail; 
  }

  Future<List<OrdersHistory>> fetchOrdersHistory() async {
    _localOrdersHistory = await _fetchData<OrdersHistory>(ordersHistoryTableId, (json) => OrdersHistory.fromJson(json));
    return _localOrdersHistory; 
  }
  
    Future<OrdersDetail> fetchOrdersDetailById(int id) async {
    if (_localOrdersDetail.isEmpty) {
      await fetchOrdersDetail(); 
    }

    
    final order = _localOrdersDetail.firstWhere(
      (order) => order.id == id,
      orElse: () => throw Exception('Order with ID $id not found in local data.'),
    );

    return order;
  }


  Future<List<Products>> fetchProductsByCartID(List<int> cartIDs) async {
    String filterFormula = cartIDs.map((id) => 'FIND("$id", {CartID})').join(' + ');

    final response = await http.get(
      Uri.parse('https://api.airtable.com/v0/$baseId/$productsTableId?filterByFormula=$filterFormula'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['records'] is List) {
        return (data['records'] as List)
            .map((record) => Products.fromJson(record['fields']))
            .toList();
      }
    } else {
      logger.e('Error fetching products: ${response.statusCode} ${response.reasonPhrase}');
    }
    return [];
  }

  Future<List<Cart>> fetchCart() async {
    _localCart = await _fetchData<Cart>(cartTableId, (json) => Cart.fromJson(json));
    return _localCart; 
  }

  Future<List<ProductsDetail>> fetchProductsDetail() async {
    _localProductsDetail = await _fetchData<ProductsDetail>(productsDetailTableId, (json) => ProductsDetail.fromJson(json));
    return _localProductsDetail; 
  }

  Future<List<T>> _fetchData<T>(String tableId, T Function(Map<dynamic, dynamic>) fromJson) async {
    final response = await http.get(
      Uri.parse('https://api.airtable.com/v0/$baseId/$tableId'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['records'] is List) {
        return (data['records'] as List)
            .map((record) => fromJson(record['fields']))
            .toList();
      }
    } else {
      logger.e('Error fetching data: ${response.statusCode} ${response.reasonPhrase}');
    }
    return [];
  }

  Future<List<Products>> searchProducts(String searchQuery) async {
    if (_localProducts.isEmpty) {
      logger.i('No local data found. Fetching products from API...');
      await fetchProducts();
    }

    return _localProducts.where((product) {
      return (product.name?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
    }).toList();
  }

  Future<void> createUser(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.airtable.com/v0/$baseId/$usersTableId'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'fields': {
            'Username': username,
            'Email': email,
            'Password': password,
          }
        }),
      );

      if (response.statusCode == 200) {
        logger.i('User created successfully: ${response.body}');
      } else {
        logger.e('Failed to create user: ${response.statusCode} ${response.reasonPhrase}');
        throw Exception('Failed to create user: ${response.body}');
      }
    } catch (e) {
      logger.e('Exception: $e');
      throw Exception('Failed to create user: $e');
    }
  }

   Future<void> updateUser(Users user) async {
    final url = 'https://api.airtable.com/v0/$baseId/$usersTableId/${user.userId}'; 
    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'fields': {
          'Username': user.userName,
          'Email': user.email,
          'Password': user.password,
        },
      }),
    );

    if (response.statusCode == 200) {
      logger.i('User updated successfully: ${response.body}');
    } else {
      logger.e('Failed to update user: ${response.statusCode} ${response.reasonPhrase}');
      throw Exception('Failed to update user: ${response.body}');
    }
  }
}
