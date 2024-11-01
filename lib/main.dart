import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sortfood/ui/auth/waiting.dart'; 
import 'package:logger/logger.dart';
import 'package:provider/provider.dart'; 
import 'package:sortfood/provider/user_provider.dart';
import 'package:sortfood/ui/home_page.dart'; 
import 'package:sortfood/ui/home_screen.dart';
import 'package:sortfood/ui/sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Logger logger = Logger();
  MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) =>const HomeScreen(),
      '/signIn': (context) =>const SignIn(),  
      '/waiting': (context) => const WaitingPage(),
    },
  );

  try {
    await dotenv.load(fileName: "lib/assets/.env");
  } catch (e) {
    logger.i('Failed to load .env file: $e');
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          color: Colors.orange,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        appBarTheme: const AppBarTheme(
          color: Colors.black,
        ),
      ),
      home: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          return userProvider.isLoggedIn ? const HomePage() : const WaitingPage();
        },
      ),
    );
  }
}
