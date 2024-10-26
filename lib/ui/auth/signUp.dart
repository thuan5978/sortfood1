
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sortfood/api/airtableservice.dart';
import 'package:sortfood/model/aaconst.dart';
import 'package:sortfood/ui/auth/signIn.dart';

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
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    usernameControl.dispose();
    emailControl.dispose();
    passControl.dispose();
    super.dispose();
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      
      _formKey.currentState!.save();
      
      final username = usernameControl.text.trim();
      final email = emailControl.text.trim();
      final pass = passControl.text.trim();

      logger.i('Signing up user with Username: $username, Email: $email');

      final airtableService = AirtableService();

      try {
        await airtableService.createUser(username, email, pass);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account created successfully!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to create account: $e")),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _header(context),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: _body(),
      ),
    );
  }

  PreferredSize _header(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.25),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: mainColor.withOpacity(0.5),
              spreadRadius: 15,
              blurRadius: 15,
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'WELCOME TO SORTFOOD',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20),
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
            const SizedBox(height: 40),
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
            const SizedBox(height: 20),
            _signInBtn(context),
            _line(),
            _signInGGBtn(context),
          ],
        ),
      ),
    );
  }

  Widget _input(BuildContext context, String title, TextEditingController input, bool isPassword, String? Function(String?)? validator) {
    return TextFormField(
      controller: input,
      obscureText: isPassword && !_isPasswordVisible, 
      decoration: InputDecoration(
        labelText: title,
        border: const OutlineInputBorder(),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null, // Only show the toggle for password fields
      ),
      validator: validator,
    );
  }
}

  Widget _signInBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignIn()),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 1.75,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey, width: 2),
        ),
        child: const Text(
          'Sign In',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _signInGGBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 300,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/icon/Google__G__logo.png',
              width: 30,
              height: 30,
            ),
            const Text(
              'Sign in with Google',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _line() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: const Divider(
            color: Colors.grey,
            thickness: 1.0,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(3),
          color: const Color.fromARGB(255, 255, 255, 255),
          child: const Text(
            'Or',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15.0,
            ),
          ),
        ),
      ],
    );
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
        color: mainColor,
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
