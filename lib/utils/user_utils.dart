import 'package:flutter/material.dart';
import 'package:sortfood/api/airtableservice.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sortfood/provider/user_provider.dart';
import 'package:sortfood/model/users.dart';
import 'package:sortfood/model/usermodel.dart';

class UserUtils {
  final AirtableService airtableService;

  UserUtils(this.airtableService);

  static Future<void> initializeUserData(BuildContext context, String email) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final users = await AirtableService().fetchUsers(); 

      final matchingUser = users.firstWhere(
        (user) => user.email?.toLowerCase() == email.toLowerCase(),
        orElse: () => Users(),
      );

      if (matchingUser.userId == null) {
        showErrorDialog(context, "Người dùng không tồn tại.");
      } else {
        final userModel = convertUsersToUserModel(matchingUser);
        await userProvider.setCurrentUser(userModel);
      }
    } catch (e) {
      Logger().e("Error initializing user data: $e");
      showErrorDialog(context, "Có lỗi xảy ra. Vui lòng thử lại.");
    }
  }

  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:const Text("Lỗi"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child:const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  static UserModel convertUsersToUserModel(Users user) {
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
}

