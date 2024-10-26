import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/constants/constant.dart';
import 'package:test_app/providers/cart_providers.dart';
import 'package:test_app/providers/login_provider.dart';
import 'package:test_app/screens/home.dart';
import 'package:test_app/screens/login_page.dart';
import 'package:test_app/screens/wish_list.dart';
import 'package:test_app/service/login_service.dart';
import 'package:test_app/widgets/cart_icon.dart';

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
    const Text('Profile'),
  ];

  final loginService = LoginService();
  Future<void> fetchToken() async {
    String? token = await loginService.getToken();
    print('Token: $token');
  }

  @override
  Widget build(BuildContext context) {
    initState() {
      fetchToken();
    }

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
        actions: [
          const CartIcon(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
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
                    : Colors.black12,
                child: Icon(
                  Provider.of<LoginProvider>(context).isLoggedIn
                      ? Icons.login
                      : Icons.person,
                  color: Provider.of<LoginProvider>(context).isLoggedIn
                      ? Colors.white
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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Products',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Wishlist',
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
