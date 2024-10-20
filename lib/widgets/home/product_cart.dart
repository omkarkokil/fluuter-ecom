import 'package:flutter/material.dart';
import 'package:test_app/screens/product_detail.dart';

class Product {
  final String imageUrl;
  final String title;
  final double price;
  final String desc;
  Product(
      {required this.imageUrl,
      required this.title,
      required this.price,
      required this.desc});
}

class ProductsPage extends StatelessWidget {
  final List<Product> products = [
    Product(
      imageUrl:
          "https://images.unsplash.com/photo-1593305841991-05c297ba4575?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8dHZ8ZW58MHx8MHx8fDA%3D",
      title: "Monitor",
      desc:
          "industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it",
      price: 29.99,
    ),
    Product(
      imageUrl:
          "https://images.unsplash.com/photo-1570464197285-9949814674a7?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fHNob2V8ZW58MHx8MHx8fDA%3D",
      desc:
          "industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it",
      title: "Product 2",
      price: 59.99,
    ),
    Product(
      imageUrl:
          "https://images.unsplash.com/photo-1515955656352-a1fa3ffcd111?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8c2hvZXxlbnwwfHwwfHx8MA%3D%3D",
      desc:
          "industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it",
      title: "Product 1",
      price: 29.99,
    ),
    Product(
      imageUrl:
          "https://images.unsplash.com/photo-1524805444758-089113d48a6d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8d2F0Y2h8ZW58MHx8MHx8fDA%3D",
      desc:
          "industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it",
      title: "Watch",
      price: 59.99,
    ),
  ];

  ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true, // Important to prevent overflow
      physics: const NeverScrollableScrollPhysics(), // Disable grid scrolling
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
        childAspectRatio: .8,
      ),
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
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
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10.0)),
              child: Image.network(
                product.imageUrl,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.title,
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
                  Text(product.desc,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
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
