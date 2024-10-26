
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sortfood/api/airtableservice.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  final TextEditingController usernameControl = TextEditingController();
  final TextEditingController emailControl = TextEditingController();
  final TextEditingController passControl = TextEditingController();
  final Logger logger = Logger();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    usernameControl.dispose();
    emailControl.dispose();
    passControl.dispose();
    super.dispose();
  }

  void _signUp() async {
  if (_formKey.currentState!.validate()) {
    final username = usernameControl.text.trim();
    final email = emailControl.text.trim();
    final pass = passControl.text.trim();

    
    logger.i('Signing up user with Username: $username, Email: $email');

    final airtableService = AirtableService();

    try {
      await airtableService.createUser(username, email, pass);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully!"))
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create account: $e"))
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Sign Up', style: TextStyle(color: Colors.white)),
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
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 105,
              height: 105,
              child: Image.asset("lib/assets/icon/logo.png", fit: BoxFit.cover),
            ),
            const SizedBox(height: 160),
            _input(context, 'Username', usernameControl, false, (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            }),
            const SizedBox(height: 20),
            _input(context, 'Email', emailControl, false, (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            }),
            const SizedBox(height: 20),
            _input(context, 'Password', passControl, true, (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            }),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: _signUp,
              child: const ButtonCustom(text: "Sign Up"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(BuildContext context, String title, TextEditingController input, bool isPassword, String? Function(String?)? validator) {
    return TextFormField(
      controller: input,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: title,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
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
