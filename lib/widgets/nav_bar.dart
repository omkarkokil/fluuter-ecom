import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/constants/constant.dart';
import 'package:test_app/providers/cart_providers.dart';
import 'package:test_app/providers/login_provider.dart';
import 'package:test_app/screens/home.dart';
import 'package:test_app/screens/login_page.dart';
import 'package:test_app/screens/profile_page.dart';
import 'package:test_app/screens/wish_list.dart';
import 'package:test_app/service/login_service.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  bool isLoggedIn = false;
  final _pages = [
    const HomeWidget(),
    const Text('Search'),
    const WishListPage(),
    const ProfilePage(),
  ];

  final loginService = LoginService();

  @override
  Widget build(BuildContext context) {
    initState() {
      Provider.of<LoginProvider>(context, listen: false).checkLoginStatus();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 10.0), // Adjust padding for leading icon if needed
          child: CircleAvatar(
            backgroundColor: primary,
            child: Icon(
              Icons.shopping_bag_outlined,
              color: Colors.black,
            ),
          ),
        ),
        leadingWidth: 60, // Match the width of the action avatar
        centerTitle: true,
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Delivery address",
              style: TextStyle(fontSize: 13, color: Colors.black45),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "92 HIGH STREET,LONDON",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: .1),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: GestureDetector(
              onTap: () async {
                final loginProvider =
                    Provider.of<LoginProvider>(context, listen: false);

                if (loginProvider.isLoggedIn) {
                  await loginProvider.logout();
                  Provider.of<CartProvider>(context, listen: false)
                      .removeAllItem(); // Await the logout function
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const LoginPage();
                  }));
                }
              },
              child: CircleAvatar(
                backgroundColor: Provider.of<LoginProvider>(context).isLoggedIn
                    ? Colors.redAccent
                    : foreground,
                child: Icon(
                  Provider.of<LoginProvider>(context).isLoggedIn
                      ? Icons.login
                      : Icons.person,
                  color: Provider.of<LoginProvider>(context).isLoggedIn
                      ? foreground
                      : Colors.black54,
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(child: _pages[_currentIndex]),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 10 / 2),
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : const Color(0xFF101015),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(_currentIndex == 0 ? Icons.home : Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(_currentIndex == 1
                  ? Icons.shopping_bag
                  : Icons.shopping_bag_outlined),
              label: 'Products',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                  _currentIndex == 2 ? Icons.favorite : Icons.favorite_outline),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                  _currentIndex == 3 ? Icons.person : Icons.person_outline),
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
          selectedFontSize: 12,
          selectedItemColor: primary,
          unselectedItemColor: whileColor40,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}
