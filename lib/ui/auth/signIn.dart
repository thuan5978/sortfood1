import 'package:flutter/material.dart';
import 'package:sortfood/model/aaconst.dart';
import 'package:sortfood/model/users.dart';
import 'package:sortfood/ui/auth/signUp.dart';
import 'package:sortfood/ui/home_page.dart';
import 'package:sortfood/api/airtableservice.dart';
import 'package:logger/logger.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignIn();
}

class _SignIn extends State<SignIn> {
  final TextEditingController userName = TextEditingController();
  final TextEditingController passWord = TextEditingController();
  bool obscurePassword = true; 
  bool _isLoading = false;
  final Logger logger = Logger();
  final AirtableService apiService = AirtableService(); 

  @override
  void dispose() {
    userName.dispose();
    passWord.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _header(context),
      body: SingleChildScrollView(
        child: _body(),
      ),
    );
  }

  // Header
  PreferredSize _header(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.25),
      child: Container(
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: mainColor.withOpacity(0.5), spreadRadius: 15, blurRadius: 15),
          ],
        ),
        child: const Center(
          child: Text('WELCOME BACK', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _body() {
    return Container(
      padding: const EdgeInsets.only(top: 70),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _inputFieldColumn(),
          const SizedBox(height: 10),
          _saveCheck(),
          _signInBtn(context),
          _signUpBtn(context),
          _line(),
          _signInGGBtn(context),
        ],
      ),
    );
  }

  Widget _inputFieldColumn() {
    return Column(
      children: [
        _inputField(userName, 'Your username', false),
        const SizedBox(height: 20),
        _passwordInputField(),
      ],
    );
  }

  Widget _inputField(TextEditingController controller, String hintText, bool isObscure) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _passwordInputField() {
    return TextField(
      controller: passWord,
      obscureText: obscurePassword,
      decoration: InputDecoration(
        hintText: 'Your password',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(obscurePassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              obscurePassword = !obscurePassword;
            });
          },
        ),
      ),
    );
  }

  bool _isCheck = false;

  Widget _saveCheck() {
    return Row(
      children: [
        Checkbox(value: _isCheck, onChanged: (value) => setState(() => _isCheck = value!)),
        const Text('Remember me next time.', style: TextStyle(color: Colors.black, fontSize: 17)),
      ],
    );
  }

  Widget _signInBtn(BuildContext context) {
    return GestureDetector(
      onTap: _isLoading ? null : () => _attemptSignIn(context),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.75,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: mainColor, width: 2),
        ),
        child: _isLoading 
            ? const Center(child: CircularProgressIndicator())
            : const Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      ),
    );
  }

  Future<void> _attemptSignIn(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final email = userName.text.trim();
    final pass = passWord.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      _showErrorDialog("Email và mật khẩu không được trống");
      setState(() {
        _isLoading = false; 
      });
      return;
    }

    try {
      List<Users> users = await apiService.fetchUsers();
      final Users user = users.firstWhere(
        (user) => user.email == email,
        orElse: () => Users(userId: null, userName: "Unknown User", email: ""),
      );

      if (user.userId == null) {
        _showErrorDialog("Tài khoản không tồn tại");
        return;
      } else if (user.password != pass) {
        _showErrorDialog("Mật khẩu không đúng");
        return;
      }

      userName.clear();
      passWord.clear();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (error) {
      logger.e("Error during sign-in: $error");
      _showErrorDialog("Có lỗi xảy ra: ${error.toString()}");
    } finally {
      setState(() {
        _isLoading = false; 
      });
    }
  }


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
          ],
        );
      },
    );
  }

  Widget _signUpBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 1.75,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey, width: 2),
        ),
        child: const Text('Sign Up', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      ),
    );
  }

  Widget _signInGGBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
      },
      child: Container(
        width: 300,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset('lib/assets/icon/Google__G__logo.png', width: 30, height: 30),
            const Text('Sign in with Google', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _line() {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Divider(color: Colors.grey, thickness: 1.0),
        Container(
          padding: const EdgeInsets.all(3),
          color: Colors.white,
          child: const Text('Or', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
