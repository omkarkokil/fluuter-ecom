import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/providers/wishlist_provider.dart';
import 'package:test_app/widgets/wish_list_card.dart';

class WishListPage extends StatelessWidget {
  const WishListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = Provider.of<WishlistProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Wishlist",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 20,
            ),
            WishListCard(products: wishlist.wishlistItems),
          ],
        ),
      ),
    );
  }
}
