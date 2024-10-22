import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/constants/constant.dart';
import 'package:test_app/providers/cart_providers.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the cart items from the provider
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems.values.toList();
    return Scaffold(
      appBar: AppBar(
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
        centerTitle: true,
        title: const Text(
          'Cart',
          style: TextStyle(
              color: Colors.black,
              fontSize: 19 // Change the text color to black
              ),
        ),
      ),
      bottomNavigationBar: cartItems.isEmpty
          ? const SizedBox.shrink()
          : Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width - 32,
                      padding:
                          const EdgeInsets.all(12.0), // Padding around the icon
                      decoration: BoxDecoration(
                        // Outlined border color
                        color: Colors.green,
                        borderRadius:
                            BorderRadius.circular(4), // Rounded corners
                        // Background color
                      ),
                      child: const Text(
                        "Continue", // Minus icon
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white, // Icon color
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: cartItems.isEmpty
                ? const Center(
                    child: Text('Your cart is empty.'),
                  )
                : Column(children: [
                    ListView.builder(
                      itemCount: cartItems.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Card(
                          elevation: 0,
                          color: Colors.transparent,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Container(
                            padding: const EdgeInsets.all(
                                10.0), // Add padding around the tile
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Leading image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    item.imageUrl,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                    width: 14), // Space between image and text
                                // Expanded to take up remaining space for text
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '\$ ${item.price}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if (item.quantity == 1) {
                                                      cartProvider.removeItem(
                                                          item.title);
                                                    } else {
                                                      cartProvider
                                                          .decrementItem(
                                                              item.title);
                                                    }
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .all(
                                                        2.0), // Padding around the icon
                                                    decoration: BoxDecoration(
                                                      // Outlined border color
                                                      border: Border.all(
                                                          color: Colors.green),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4), // Rounded corners
                                                      // Background color
                                                    ),
                                                    child: const Icon(
                                                      Icons
                                                          .remove, // Minus icon
                                                      color: Colors
                                                          .green, // Icon color
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                    width:
                                                        16), // Space between the buttons
                                                Text(
                                                  item.quantity
                                                      .toString(), // Quantity
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                                const SizedBox(width: 16),
                                                // Increment button
                                                GestureDetector(
                                                  onTap: () {
                                                    cartProvider.incremrentItem(
                                                        item.title);
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .all(
                                                        2.0), // Padding around the icon
                                                    decoration: BoxDecoration(
                                                      // Outlined border color
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4), // Rounded corners
                                                      // Background color
                                                    ),
                                                    child: const Icon(
                                                      Icons.add, // Minus icon
                                                      color: Colors
                                                          .white, // Icon color
                                                    ),
                                                  ),
                                                )
                                              ]),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Trailing delete button
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(
                      thickness: 1, // Set thickness of the line
                      color: Colors.grey, // Color of the divider
                    ),
                    const SizedBox(
                        height: 10), // Space between the divider and the total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(fontSize: 16, color: blackColor60),
                        ),
                        Text(
                          '\$ ${cartProvider.totalAmount()}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ])),
      ),
    );
  }
}
