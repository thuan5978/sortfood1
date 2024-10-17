import 'package:flutter/material.dart';
import 'package:sortfood/ui/forgot_password.dart';
class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override 
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  final TextEditingController emailControl = TextEditingController();
  final TextEditingController passControl = TextEditingController();

  @override
  void dispose() {
    emailControl.dispose();
    passControl.dispose();
    super.dispose();
  }

  void _signIn() { 
    final email = emailControl.text.trim();
    final pass = passControl.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email và mật khẩu không được trống"))
      );
      return;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.orange, iconTheme:const IconThemeData(color: Colors.white),
      title: const Text('Sign In', style: TextStyle(color: Colors.white),)),
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
            child: 
              GestureDetector(
              onTap: _forgotPassword, 
              child: const Text("Forgot Password?", style: TextStyle(color: Color.fromARGB(255, 240, 150, 14)),textAlign: TextAlign.end,),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _signIn, 
            child: const ButtonCustom(text: "Sign In"),
          ),
          


        const SizedBox(height: 20),
          
        ],
      ),
    );
  } 

  Widget _input(BuildContext context, String title, TextEditingController input, bool isPassword) {
    return TextField(
      controller: input,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: title,
        border: const OutlineInputBorder(),
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
