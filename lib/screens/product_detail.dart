import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:test_app/providers/cart_providers.dart';
import 'package:test_app/widgets/cart_icon.dart';

class ProductDetailsPage extends StatefulWidget {
  final dynamic product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ProductDetailsPage> {
  int _itemCount = 1;

  void _incrementCounter() {
    setState(() {
      _itemCount++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_itemCount > 0) {
        _itemCount--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 17,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: false,
        actions: const [CartIcon()],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Decrement button
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              GestureDetector(
                onTap: () {
                  _decrementCounter();
                },
                child: Container(
                  padding: const EdgeInsets.all(2.0), // Padding around the icon
                  decoration: BoxDecoration(
                    // Outlined border color
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(4), // Rounded corners
                    // Background color
                  ),
                  child: const Icon(
                    Icons.remove, // Minus icon
                    color: Colors.green, // Icon color
                  ),
                ),
              ),
              const SizedBox(width: 16), // Space between the buttons
              Text(
                '$_itemCount', // Quantity
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 16),
              // Increment button
              GestureDetector(
                onTap: () {
                  _incrementCounter();
                },
                child: Container(
                  padding: const EdgeInsets.all(2.0), // Padding around the icon
                  decoration: BoxDecoration(
                    // Outlined border color
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4), // Rounded corners
                    // Background color
                  ),
                  child: const Icon(
                    Icons.add, // Minus icon
                    color: Colors.white, // Icon color
                  ),
                ),
              )
            ]),
            // Quantity display
            // Add to Cart button
            GestureDetector(
                onTap: () {
                  final cartProvider =
                      Provider.of<CartProvider>(context, listen: false);
                  cartProvider.addItem(
                    widget.product.name, // Product ID
                    widget.product.name, // Product name
                    widget.product.price, // Product price
                    _itemCount,
                    // Quantity to add
                    widget.product.img[0], // Product price
                    widget.product.desc, // Product price
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Added to cart'),
                    ),
                  );
                  print(cartProvider.cartItems);
                },
                child: Container(
                  width: 140,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: const Center(
                    child: Text('Add to Cart',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                )),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  widget.product.img[0],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 5.0), // Padding around the badge
                decoration: BoxDecoration(
                  color: Colors.green, // Badge background color
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                child: const Text(
                  "Free Shipping", // Badge text
                  style: TextStyle(
                      color: Colors.white, fontSize: 12), // Badge text style
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(widget.product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  )),
              const SizedBox(
                height: 10,
              ),
              HtmlWidget(widget.product.desc),
              // Text(widget.product.desc,
              //     style: const TextStyle(
              //       color: whileColor40,
              //     )),
              const SizedBox(
                height: 20,
              ),
              Text(
                '\$ ${widget.product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
