import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:sortfood/model/orders.dart';
import 'package:sortfood/model/products.dart';
import 'package:sortfood/model/users.dart';

class AirtableService {
  final String apiKey = dotenv.env['API_KEY'] ?? '';
  final String baseId = dotenv.env['BASE_ID'] ?? '';
  final String usersTableId = dotenv.env['USERS_ID'] ?? '';
  final String productsTableId = dotenv.env['PRODUCTS_ID'] ?? '';
  final String ordersTableId = dotenv.env['ORDERS_ID'] ?? '';

  final Logger logger = Logger();

  
  Future<List<Users>> fetchUsers() async {
    return _fetchData<Users>(usersTableId, (json) => Users.fromJson(json));
  }

  
  Future<List<Products>> fetchProducts() async {
    return _fetchData<Products>(productsTableId, (json) => Products.fromJson(json));
  }

  
  Future<List<Order>> fetchOrders() async {
    return _fetchData<Order>(ordersTableId, (json) => Order.fromJson(json));
  }

  
  Future<List<T>> _fetchData<T>(String tableId, T Function(Map<String, dynamic>) fromJson) async {
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
      List<T> items = (data['records'] as List)
          .map((record) => fromJson(record['fields'])) 
          .toList();
      logger.i('Parsed items: $items'); 
      return items;
    } else {
      logger.i('Error: ${response.statusCode} ${response.reasonPhrase}');
      throw Exception('Failed to load data from $tableId: ${response.body}');
    }
  } catch (e) {
    logger.i('Exception: $e');
    throw Exception('Failed to fetch data from $tableId: $e');
  }
}


    Future<List<Products>> searchProducts(String searchQuery) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.airtable.com/v0/$baseId/$productsTableId?filterByFormula=SEARCH("$searchQuery", {Name})'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Products> products = (data['records'] as List)
            .map((record) => Products.fromJson(record['fields']))
            .toList();
        return products;
      } else {
        logger.i('Error: ${response.statusCode} ${response.reasonPhrase}');
        throw Exception('Failed to search products: ${response.body}');
      }
    } catch (e) {
      logger.i('Exception: $e');
      throw Exception('Failed to search products: $e');
    }
  }
}
