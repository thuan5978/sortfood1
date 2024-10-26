import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:sortfood/model/aaconst.dart';
import 'package:sortfood/model/users.dart';
import 'package:sortfood/ui/list_settings.dart';
import 'package:sortfood/api/airtableservice.dart';

class AccountCenter2 extends StatefulWidget {
  const AccountCenter2({super.key});

  @override
  State<AccountCenter2> createState() => _AccountCenter();
}

class _AccountCenter extends State<AccountCenter2> {
  Users user = Users();
  TextEditingController userName = TextEditingController();
  TextEditingController passWord = TextEditingController();
  TextEditingController emailControl = TextEditingController();
  final AirtableService _airtableService = AirtableService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
  List<Users> users = await _airtableService.fetchUsers();
    if (users.isNotEmpty) {
      setState(() {
        user = users[0];
        userName.text = user.userName ?? '';
        passWord.text = user.password ?? '';
        emailControl.text = user.email ?? '';
        user.phone ??= "Không có thông tin";
        user.img = (user.img?.isNotEmpty ?? false) ? user.img : "lib/assets/icon/arvarta.png";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        appBar: _header(context),
        body: const SettingsList(),
      ),
    );
  }

  PreferredSize _header(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(getMainHeight(context) / 3),
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.black26, width: 1)),
          ),
          child: Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: Image.asset(
                          user.img ?? 'lib/assets/icon/arvarta.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -5,
                      right: 0,
                      child: IconButton(
                        onPressed: () => _showEdit(context),
                        icon: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  user.userName ?? "Tên không xác định",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  phoneFormated(user.phone ?? ''),
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showEdit(BuildContext context) {
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      confirmBtnText: 'Cập nhật',
      widget: SingleChildScrollView(
        child: Column(
          children: [
            _imgEdit(context),
            const SizedBox(height: 20),
            InputFieldCustom(controller: userName, hintText: 'Tên người dùng của bạn', isObsucre: false),
            InputFieldCustom(controller: passWord, hintText: 'Mật khẩu của bạn', isObsucre: false),
            InputFieldCustom(controller: emailControl, hintText: 'Email của bạn', isObsucre: false),
          ],
        ),
      ),
      onConfirmBtnTap: () async => await _updateUserInfo(),
    );
  }

  Future<void> _updateUserInfo() async {
    user.userName = userName.text;
    user.email = emailControl.text;
    user.password = passWord.text;

    try {
      await _airtableService.updateUser(user);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Cập nhật thành công!',
      );
      setState(() {});
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Cập nhật thất bại!',
        text: e.toString(),
      );
    }
  }

  Widget _imgEdit(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Add image picker functionality here
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              user.img ?? '',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 1,
            left: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.black12.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Chỉnh sửa',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
