import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String avatar = 'https://via.placeholder.com/150';
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Cài đặt', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(avatar),
                  ),
                  TextButton.icon(
                    onPressed: _changeAvatar,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Cập nhật ảnh đại diện'),
                  ),
                ],
              ),
            ),
            const Divider(),
            _buildTextField('Tên', nameController),
            _buildTextField('Email', emailController),
            _buildTextField('Số điện thoại', phoneController),
            _buildTextField('Địa chỉ giao hàng', addressController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updatePersonalInfo,
              child: const Text('Lưu thông tin cá nhân'),
            ),
            const Divider(),
            _buildTextField('Mật khẩu hiện tại', currentPasswordController, obscureText: true),
            _buildTextField('Mật khẩu mới', newPasswordController, obscureText: true),
            _buildTextField('Xác nhận mật khẩu mới', confirmPasswordController, obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _changePassword,
              child: const Text('Thay đổi mật khẩu'),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Bật thông báo đẩy'),
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
            const Divider(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: _deleteAccount,
              child: const Text('Xóa tài khoản'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void _updatePersonalInfo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thông tin cá nhân đã được cập nhật thành công!')),
    );
  }

  void _changePassword() {
    if (newPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu mới và xác nhận không khớp')),
      );
      return;
    }

    if (newPasswordController.text.length < 8 || !newPasswordController.text.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu phải dài hơn 8 ký tự và chứa ký tự đặc biệt!')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mật khẩu đã được thay đổi thành công!')),
    );
  }

  void _changeAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        avatar = pickedFile.path; 
      });
    }
  }

  void _deleteAccount() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tài khoản đã được xóa!')),
    );
  }
}
