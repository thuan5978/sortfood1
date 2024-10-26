import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sortfood/model/usermodel.dart';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:sortfood/model/orders.dart';

class UserProvider with ChangeNotifier {
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  final Logger logger = Logger();

  int? get currentUserId => _currentUser?.userId;

  List<Order> orders = [];

  //bool isAdmin = false;

  void setOrders(List<Order> newOrders) {
    orders = newOrders;
    notifyListeners();
  }

  void addOrder(Order order) {
    orders.add(order);
    notifyListeners();
  }

  // void toggleAdminStatus(bool status) {
  // isAdmin = status;
  //  notifyListeners();
  // }

  Future<void> loadUserFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('currentUser');
    if (userData != null) {
      try {
        logger.i("Loading user data from SharedPreferences.");
        _currentUser = UserModel.fromJson(json.decode(userData));
        notifyListeners();
        logger.i("User data loaded successfully: ${_currentUser?.toJson()}");
      } catch (e) {
        logger.e("Error loading user from SharedPreferences: $e");
      }
    } else {
      logger.i("No user data found in SharedPreferences.");
    }
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUser');
    notifyListeners();
  }
}
