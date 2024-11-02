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
        iconTheme: const IconThemeData(color: Colors.white),
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
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _changeAvatar,
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    label: const Text('Cập nhật ảnh đại diện', style: TextStyle(color: Colors.white)),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            _buildTextField('Tên', nameController),
            _buildTextField('Email', emailController),
            _buildTextField('Số điện thoại', phoneController),
            _buildTextField('Địa chỉ giao hàng', addressController),
            const SizedBox(height: 20),
            _buildElevatedButton('Lưu thông tin cá nhân', _updatePersonalInfo),
            const SizedBox(height: 20),
            const Divider(),
            _buildTextField('Mật khẩu hiện tại', currentPasswordController, obscureText: true),
            _buildTextField('Mật khẩu mới', newPasswordController, obscureText: true),
            _buildTextField('Xác nhận mật khẩu mới', confirmPasswordController, obscureText: true),
            const SizedBox(height: 20),
            _buildElevatedButton('Thay đổi mật khẩu', _changePassword),
            const SizedBox(height: 20),
            const Divider(),
            SwitchListTile(
              title: const Text('Bật thông báo đẩy', style: TextStyle(fontSize: 16)),
              value: notificationsEnabled,
              activeColor: Colors.orange,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
            const Divider(),
            _buildElevatedButton('Xóa tài khoản', _deleteAccount, color: Colors.red),
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
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget _buildElevatedButton(String text, VoidCallback onPressed, {Color color = Colors.orange}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 16)),
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
