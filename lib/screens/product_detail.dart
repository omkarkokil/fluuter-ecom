import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:test_app/constants/constant.dart';
import 'package:test_app/providers/cart_providers.dart';
import 'package:test_app/providers/login_provider.dart';
import 'package:test_app/widgets/cart_icon.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetailsPage extends StatefulWidget {
  final dynamic product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ProductDetailsPage> {
  int _itemCount = 1;
  int _currentIndex = 0;

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
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: background,
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
        child: GestureDetector(
            onTap: () {
              final cartProvider =
                  Provider.of<CartProvider>(context, listen: false);
              final loginProvider =
                  Provider.of<LoginProvider>(context, listen: false);

              if (loginProvider.isLoggedIn) {
                cartProvider.addItem(
                  widget.product.name, // Product ID
                  widget.product.name, // Product name
                  widget.product.price, // Product price
                  _itemCount,
                  // Quantity to add
                  widget.product.img[0], // Product price
                  widget.product.desc, // Product price
                );

                Fluttertoast.showToast(
                    msg: 'Added to cart', // Your message
                    toastLength: Toast.LENGTH_SHORT, // Length of the toast
                    gravity: ToastGravity.BOTTOM, // Position of the toast
                    timeInSecForIosWeb:
                        1, // Duration in seconds for iOS and web
                    backgroundColor: Colors.black, // Background color
                    textColor: Colors.white, // Text color
                    fontSize: 16.0 // Font size
                    );
              } else {
                Fluttertoast.showToast(
                    msg: 'Please login to add to cart', // Your message
                    toastLength: Toast.LENGTH_SHORT, // Length of the toast
                    gravity: ToastGravity.BOTTOM, // Position of the toast
                    timeInSecForIosWeb:
                        1, // Duration in seconds for iOS and web
                    backgroundColor: Colors.black, // Background color
                    textColor: Colors.white, // Text color
                    fontSize: 16.0 // Font size
                    );
                return;
              }

              print(cartProvider.cartItems);
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: primary, borderRadius: BorderRadius.circular(10.0)),
              child: const Center(
                child: Text('Add to Cart',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ),
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: background,
              child: Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 250,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    items: widget.product.img.map<Widget>((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Image.network(
                          item,
                          fit: BoxFit.contain,
                          width: double.infinity,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(widget.product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 5.0), // Padding around the badge
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.black38),
                              // Badge background color
                              borderRadius:
                                  BorderRadius.circular(10), // Rounded corners
                            ),
                            child: const Row(children: [
                              Icon(
                                Icons.star,
                                color: secondary,
                                size: 18,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                "4.8", // Badge text
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.bold), // Badge text style
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "117 reviews", // Badge text
                                style: TextStyle(
                                    fontSize: 12,
                                    color: blackColor40), // Badge text style
                              ),
                            ]),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 5.0), // Padding around the badge
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.black38),
                              // Badge background color
                              borderRadius:
                                  BorderRadius.circular(10), // Rounded corners
                            ),

                            child: const Row(
                              children: [
                                Icon(
                                  Icons.thumb_up,
                                  color: primary,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "94%",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 5.0), // Padding around the badge
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.black38),
                              // Badge background color
                              borderRadius:
                                  BorderRadius.circular(10), // Rounded corners
                            ),

                            child: const Row(
                              children: [
                                Icon(
                                  Icons.message,
                                  color: Colors.grey,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "6",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: background,
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Row(children: [
                          Text(
                            '₹ ${widget.product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      HtmlWidget(widget.product.desc),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
