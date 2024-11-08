import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sortfood/model/usermodel.dart';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:sortfood/model/orders.dart';
import 'package:sortfood/model/users.dart';
import 'package:sortfood/api/airtableservice.dart';

class UserProvider with ChangeNotifier {
  UserModel? _currentUser;
  Users? _user;

  UserModel? get currentUser => _currentUser;
  Users? get user => _user; 
  bool get isLoggedIn => _currentUser != null;

  final Logger logger = Logger();
  int? get currentUserId => _currentUser?.userId;
  List<Order> orders = [];
  final AirtableService airtableService = AirtableService();
  
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setOrders(List<Order> newOrders) {
    orders = newOrders;
    notifyListeners();
  }

  void addOrder(Order order) {
    orders.add(order);
    notifyListeners();
  }

      Future<void> loadUserData(int? userId) async {
      if (userId != null) {
        _isLoading = true; 
        notifyListeners();
        
        try {
          Users? fetchedUser = await airtableService.fetchUserById(userId);
          if (fetchedUser != null) {
            _user = fetchedUser; 
            notifyListeners();
          } else {
            logger.e('User not found for UserID: $userId');
          }
        } catch (e) {
          logger.e('Error fetching user data: $e');
        } finally {
          _isLoading = false; 
          notifyListeners();
        }
      } else {
        logger.e('Invalid userId: $userId');
      }
    }
   bool get isAdmin {
    return currentUser?.position?.toLowerCase() == 'admin';
  }
  
  Future<void> setCurrentUser(UserModel user) async {
    _currentUser = user;
    final prefs = await SharedPreferences.getInstance();
    try {
      logger.i("Saving user data to SharedPreferences.");
      await prefs.setString('currentUser', json.encode(user.toJson()));
      notifyListeners();
      logger.i("User data saved successfully: ${user.toJson()}");
    } catch (e) {
      logger.e("Error saving user to SharedPreferences: $e");
    }
  }

  Future<void> clearUser() async {
    _currentUser = null;
    _user = null; 
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUser');
    notifyListeners();
  }
}
