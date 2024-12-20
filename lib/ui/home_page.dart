import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:sortfood/ui/auth/account_center.dart';
import 'package:sortfood/ui/history_page.dart';
import 'package:sortfood/ui/order_page.dart';
import 'package:sortfood/ui/home_screen.dart';
import 'package:sortfood/provider/user_provider.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    final userProvider = Provider.of<UserProvider>(context);
    final userId = userProvider.currentUserId;

    
    final List<Widget> pages = [
      const HomeScreen(),
      const HistoryPage(),
      const OrderPage(),
      AccountCenter2(key: const Key('account_center'), userId: userId), // Pass userId here
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Order'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
