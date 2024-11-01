import 'package:flutter/material.dart';
import 'package:sortfood/model/aaconst.dart';
import 'package:sortfood/ui/auth/signUp.dart';
import 'package:sortfood/ui/home_page.dart';
import 'package:sortfood/api/airtableservice.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sortfood/provider/user_provider.dart';
import 'package:sortfood/model/usermodel.dart';
import 'package:sortfood/model/users.dart';
import 'package:sortfood/utils/user_utils.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  bool obscurePassword = true; 
  bool _isLoading = false;
  final Logger logger = Logger();
  final AirtableService apiService = AirtableService(); 

  @override
  void dispose() {
    emailController.dispose();
    passWordController.dispose();
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
        _inputField(emailController, 'Your email', false),
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
      controller: passWordController,
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

  final inputEmail = emailController.text.trim();  
  final pass = passWordController.text.trim();

    if (inputEmail.isEmpty || pass.isEmpty) {
      UserUtils.showErrorDialog(context, "Email and password must not be empty.");
      setState(() {
        _isLoading = false; 
      });
      return;
    }

    try {
      await UserUtils.initializeUserData(context, inputEmail);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.currentUser;

      if (user == null || user.password != pass) {
        UserUtils.showErrorDialog(context, "Incorrect password.");
        return;
      }

      emailController.clear();
      passWordController.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (error) {
      logger.e("Error during sign-in: $error");
      UserUtils.showErrorDialog(context, "An error occurred during sign-in. Please try again later.");
    } finally {
      setState(() {
        _isLoading = false; 
      });
    }
  }

  UserModel convertUsersToUserModel(Users user) {
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
        // Handle Google Sign-In
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 1.75,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey, width: 2),
        ),
        child: const Text('Sign In with Google', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      ),
    );
  }

  Widget _line() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 100, height: 1, color: Colors.grey),
        const Text('OR', style: TextStyle(color: Colors.black, fontSize: 20)),
        Container(width: 100, height: 1, color: Colors.grey),
      ],
    );
  }

}

