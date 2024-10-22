import 'package:flutter/material.dart';
import 'package:test_app/constants/constant.dart';
import 'package:test_app/screens/home.dart';
import 'package:test_app/screens/wish_list.dart';
import 'package:test_app/widgets/cart_icon.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  final _pages = [
    const HomeWidget(),
    const Text('Search'),
    const WishListPage(),
    const Text('Profile'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: Icon(
          Icons.shopping_bag,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.green
              : Colors.green,
        ),
        leadingWidth: 0,
        centerTitle: false,
        title: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            'ONESTOPSHOP',
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 16, color: Colors.green),
          ),
        ),
        actions: const [CartIcon()],
      ),
      body: SafeArea(child: _pages[_currentIndex]),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 10 / 2),
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : const Color(0xFF101015),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index != _currentIndex) {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : const Color(0xFF101015),
          type: BottomNavigationBarType.fixed,
          // selectedLabelStyle: TextStyle(color: primaryColor),
          selectedFontSize: 12,
          selectedItemColor: Colors.green,
          unselectedItemColor: whileColor40,
        ),
      ),
    );
  }
}
