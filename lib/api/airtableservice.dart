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
  
  Future<OrdersDetail> fetchOrdersDetailHistoryById(int? orderdetailID, int? orderHistoryID) async {
    if (_localOrdersDetail.isEmpty) {
      await fetchOrdersDetail(); 
    }

    final url = Uri.parse(
      'https://api.airtable.com/v0/appIgT6YVxKDFM1Ab/tblhxZuxM5WZBjgBT?filterByFormula=AND({OrderdetailID}="$orderdetailID",{OrderHistoryID}="$orderHistoryID")'
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['records'].isNotEmpty) {
        return OrdersDetail.fromJson(data['records'][0]['fields']);
      } else {
        throw Exception('No order details found for IDs: orderdetailID=$orderdetailID, orderHistoryID=$orderHistoryID');
      }
    } else {
      throw Exception('Failed to fetch order details: ${response.statusCode}');
    }
  }

  Future<OrdersDetail> fetchOrdersDetailById(int? id) async {
      
      if (_localOrdersDetail.isEmpty) {
        await fetchOrdersDetail(); 
      }

      final url = Uri.parse(
        'https://api.airtable.com/v0/appIgT6YVxKDFM1Ab/tblhxZuxM5WZBjgBT?filterByFormula={OrderdetailID}="$id"'
      );

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['records'].isNotEmpty) {
          
          return OrdersDetail.fromJson(data['records'][0]['fields']);
        } else {
          throw Exception('No order details found for ID: $id');
        }
      } else {
        throw Exception('Failed to fetch order details: ${response.statusCode}');
      }
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

  Future<Map<dynamic, dynamic>> fetchRecordById(String recordId, String tableId) async {
  
  final url = 'https://api.airtable.com/v0/$baseId/$tableId/$recordId';
  
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['fields'];
    } else {
      logger.e('Error fetching record: ${response.statusCode} ${response.reasonPhrase}');
    }
  } catch (e) {
    logger.e('Exception: $e');
  }

  return {};
}




  Future<List<T>> _fetchData<T>(
    String tableId, 
    T Function(Map<dynamic, dynamic>) fromJson
  ) async {
    try {
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
        } else {
          logger.e('Unexpected data format: ${data.toString()}');
        }
      } else {
        logger.e('Error fetching data: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      logger.e('Exception occurred: $e');
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
  
  final queryUrl = 'https://api.airtable.com/v0/$baseId/$usersTableId?filterByFormula={UserID}=${user.userId}';
  final queryResponse = await http.get(
    Uri.parse(queryUrl),
    headers: {
      'Authorization': 'Bearer $apiKey',
    },
  );

  if (queryResponse.statusCode == 200) {
    final data = jsonDecode(queryResponse.body);
      if (data['records'].isNotEmpty) {
        final recordId = data['records'][0]['id'];
        final updateUrl = 'https://api.airtable.com/v0/$baseId/$usersTableId/$recordId';
        final updateResponse = await http.patch(
          Uri.parse(updateUrl),
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'fields': {
              'UserName': user.userName,
              'Email': user.email,
              'Password': user.password,
            },
          }),
        );

        if (updateResponse.statusCode == 200) {
          logger.i('Người dùng đã được cập nhật thành công: ${updateResponse.body}');
        } else {
          logger.e('Cập nhật người dùng không thành công: ${updateResponse.statusCode} ${updateResponse.reasonPhrase}');
          logger.e('Body: ${updateResponse.body}'); 
        }
      } else {
        logger.e('Không tìm thấy người dùng với UserID: ${user.userId}');
      }
    } else {
      logger.e('Không thể truy xuất dữ liệu người dùng: ${queryResponse.statusCode} ${queryResponse.reasonPhrase}');
    }
  }

  Future<Users?> fetchUserById(int? userId) async {
  
  final queryUrl = 'https://api.airtable.com/v0/$baseId/$usersTableId?filterByFormula={UserID}="$userId"';
  
  final queryResponse = await http.get(
    Uri.parse(queryUrl),
    headers: {
      'Authorization': 'Bearer $apiKey',
    },
  );

    if (queryResponse.statusCode == 200) {
      final data = jsonDecode(queryResponse.body);
      
      if (data['records'].isNotEmpty) {
        
        final record = data['records'][0];
        final fields = record['fields'];
        return Users(
          userId: userId,
          userName: fields['UserName'] ?? '',
          email: fields['Email'] ?? '',
          phone: fields['Phone'] ?? '',
          password: fields['Password'] ?? '',
          address: fields['Address'] ?? '',
        );
      } else {
        logger.e('Không tìm thấy người dùng với UserID: $userId');
        return null; 
      }
    } else {
      logger.e('Không thể truy xuất dữ liệu người dùng: ${queryResponse.statusCode} ${queryResponse.reasonPhrase}');
      return null; 
    }
  }
}
