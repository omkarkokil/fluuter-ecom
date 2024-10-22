import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/providers/cart_providers.dart';
import 'package:test_app/screens/cart_page.dart';

class CartIcon extends StatelessWidget {
  const CartIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    return Stack(
      children: [
        IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartPage(),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart)),
        if (cartProvider.cartItems.isNotEmpty)
          Positioned(
            right: 2,
            top: 2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red, // Badge color
                shape: BoxShape.circle, // Circular badge
              ),
              child: Text(
                cartProvider.cartItems.length
                    .toString(), // Number of items in the cart
                style: const TextStyle(
                  color: Colors.white, // Text color
                  fontSize: 12, // Text size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
