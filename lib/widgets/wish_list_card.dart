import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/Models/model.dart';
import 'package:test_app/providers/wishlist_provider.dart';
import 'package:test_app/screens/product_detail.dart';

class WishListCard extends StatelessWidget {
  final Map<String, Products> products;

  const WishListCard({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return products.isEmpty
        ? const Text(
            'No items in wishlist',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          )
        : GridView.builder(
            shrinkWrap: true, // Important to prevent overflow
            physics:
                const NeverScrollableScrollPhysics(), // Disable grid scrolling
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              childAspectRatio: .8,
            ),
            itemBuilder: (context, index) {
              final productEntry = products.entries.toList()[index];
              final product = productEntry.value;
              return ProductCard(product: product);
            },
          );
  }
}

class ProductCard extends StatelessWidget {
  final Products product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailsPage(product: product)));
      },
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10.0)),
                  child: Image.network(
                    product.img[0],
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 5,
                  child: IconButton(
                    color:
                        wishlistProvider.wishlistItems.containsKey(product.name)
                            ? Colors.red
                            : Colors.grey,
                    onPressed: () {
                      wishlistProvider.mutateWishList(product);
                    },
                    icon: Icon(
                        wishlistProvider.wishlistItems.containsKey(product.name)
                            ? Icons.favorite
                            : Icons.favorite_border),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: ElevatedButton(
            //     onPressed: () {
            //       // Handle add to cart action
            //     },
            //     child: const Text('Add to Cart'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
