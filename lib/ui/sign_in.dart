import 'package:flutter/material.dart';
import 'package:sortfood/ui/forgot_password.dart';
import 'package:sortfood/ui/home_screen.dart'; 
import 'package:sortfood/model/users.dart';
import 'package:sortfood/api/airtableservice.dart';
import 'package:logger/logger.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  final TextEditingController emailControl = TextEditingController();
  final TextEditingController passControl = TextEditingController();
  bool isLoading = false; 
  bool obscurePassword = true; 
  final Logger logger = Logger();

  @override
  void dispose() {
    emailControl.dispose();
    passControl.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final email = emailControl.text.trim();
    final pass = passControl.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email và mật khẩu không được trống")),
      );
      return;
    }

    setState(() {
      isLoading = true; 
    });

    try {
      AirtableService airtableService = AirtableService();
      List<Users> users = await airtableService.fetchUsers();

      final Users user = users.firstWhere(
        (user) => user.email == email && user.password == pass,
        orElse: () => Users(id: null, email: "")
      );

      if (!mounted) return;

      if (user.id == null) {
        setState(() {
          isLoading = false; 
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tài khoản không tồn tại")),
        );
        return;
      }

      setState(() {
        isLoading = false; 
      });
      emailControl.clear(); 
      passControl.clear();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        isLoading = false; 
      });
      
      logger.e("Error during sign-in: $error");
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Có lỗi xảy ra: ${error.toString()}")),
      );
    }
  }

  void _forgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPassword(),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Sign In', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 105,
            height: 105,
            child: Image.asset("lib/assets/icon/logo.png", fit: BoxFit.cover),
          ),
          const SizedBox(height: 120),
          _input(context, 'Email', emailControl, false),
          const SizedBox(height: 20),
          _input(context, 'Password', passControl, true),
          const SizedBox(height: 40),
          SizedBox(
            width: width,
            child: GestureDetector(
              onTap: _forgotPassword,
              child: const Text(
                "Forgot Password?", 
                style: TextStyle(color: Color.fromARGB(255, 240, 150, 14)),
                textAlign: TextAlign.end,
              ),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: isLoading ? null : _signIn, 
            child: isLoading 
                ? const CircularProgressIndicator() 
                : const ButtonCustom(text: "Sign In"),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _input(BuildContext context, String title, TextEditingController input, bool isPassword) {
    return TextField(
      controller: input,
      obscureText: isPassword && obscurePassword,
      decoration: InputDecoration(
        labelText: title,
        border: const OutlineInputBorder(),
        suffixIcon: isPassword 
            ? IconButton(
                icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
                onPressed: _togglePasswordVisibility,
              )
            : null,
      ),
    );
  }
}

class ButtonCustom extends StatelessWidget {
  final String text;

  const ButtonCustom({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
