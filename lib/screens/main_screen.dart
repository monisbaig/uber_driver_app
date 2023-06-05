import 'package:flutter/material.dart';
import 'package:uber_driver_app/screens/nav_pages/earning_screen.dart';
import 'package:uber_driver_app/screens/nav_pages/home_screen.dart';
import 'package:uber_driver_app/screens/nav_pages/profile_screen.dart';
import 'package:uber_driver_app/screens/nav_pages/rating_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List pages = [
    const HomeScreen(),
    const EarningScreen(),
    const RatingScreen(),
    const ProfileScreen(),
  ];

  int currentIndex = 0;

  void selectPage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        elevation: 0,
        currentIndex: currentIndex,
        onTap: selectPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.credit_card_outlined,
            ),
            label: 'Earnings',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.star_border_outlined,
            ),
            label: 'Ratings',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
