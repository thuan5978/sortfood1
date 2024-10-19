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
  final String apiKey = dotenv.env['API_KEY'] ?? '';
  final String baseId = dotenv.env['BASE_ID'] ?? '';
  final String usersTableId = dotenv.env['USERS_ID'] ?? '';
  final String productsTableId = dotenv.env['PRODUCTS_ID'] ?? '';
  final String ordersTableId = dotenv.env['ORDERS_ID'] ?? '';
  final String ordersHistoryTableId = dotenv.env['ORDERS_HISTORY_ID'] ?? ''; 
  final String ordersDetailTableId = dotenv.env['ORDERS_DETAIL_ID'] ?? ''; 
  final String cartTableId = dotenv.env['CART_ID'] ?? '';
  final String productsDetailTableId = dotenv.env['PRODUCTS_DETAIL_ID'] ?? ''; 

  final Logger logger = Logger();

  List<Products> _localProducts = [];
  List<OrdersHistory> _localOrdersHistory = []; 
  List<OrdersDetail> _localOrdersDetail = []; 
  List<Cart> _localCart = []; 
  List<ProductsDetail> _localProductsDetail = []; 

  AirtableService() {
    if (apiKey.isEmpty || baseId.isEmpty || usersTableId.isEmpty || productsTableId.isEmpty || ordersTableId.isEmpty || ordersHistoryTableId.isEmpty || ordersDetailTableId.isEmpty || cartTableId.isEmpty || productsDetailTableId.isEmpty) {
      logger.w('One or more environment variables are not set. Please check your configuration.');
    }
  }

  Future<List<Users>> fetchUsers() async {
    return _fetchData<Users>(usersTableId, (json) => Users.fromJson(json));
  }

  Future<List<Products>> fetchProducts() async {
    _localProducts = await _fetchData<Products>(productsTableId, (json) => Products.fromJson(json));
    return _localProducts;
  }

  Future<List<Order>> fetchOrders() async {
    return _fetchData<Order>(ordersTableId, (json) => Order.fromJson(json));
  }

  Future<List<OrdersHistory>> fetchOrdersHistory() async {
    _localOrdersHistory = await _fetchData<OrdersHistory>(ordersHistoryTableId, (json) => OrdersHistory.fromJson(json));
    return _localOrdersHistory;
  }

  Future<List<OrdersDetail>> fetchOrdersDetail() async {
    _localOrdersDetail = await _fetchData<OrdersDetail>(ordersDetailTableId, (json) => OrdersDetail.fromJson(json));
    return _localOrdersDetail;
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
    try {
      final response = await http.get(
        Uri.parse('https://api.airtable.com/v0/$baseId/$tableId'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
      );

      logger.i('Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['records'] is List) {
          List<T> items = (data['records'] as List)
              .map((record) {
                if (record['fields'] is Map) {
                  return fromJson(record['fields']);
                } else {
                  throw Exception('Expected fields to be a Map, got ${record['fields'].runtimeType}');
                }
              })
              .toList();
          
          logger.i('Parsed items: $items');
          return items;
        } else {
          throw Exception('Expected records to be a List, got ${data['records'].runtimeType}');
        }
      } else {
        logger.e('Error: ${response.statusCode} ${response.reasonPhrase}');
        throw Exception('Failed to load data from $tableId: ${response.body}');
      }
    } catch (e) {
      logger.e('Exception: $e');
      throw Exception('Failed to fetch data from $tableId: $e');
    }
  }

  Future<List<Products>> searchProducts(String searchQuery) async {
    if (_localProducts.isEmpty) {
      logger.i('No local data found. Fetching products from API...');
      await fetchProducts();
    }

    List<Products> filteredProducts = _localProducts.where((product) {
      return (product.name?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
    }).toList();

    return filteredProducts;
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
}
