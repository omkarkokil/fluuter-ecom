import 'package:flutter/material.dart';
import 'package:test_app/widgets/home/product_cart.dart';

class HomePage extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            // Load more products when scrolled to the bottom
            // Add your logic to fetch more products here
          }
          return false;
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              // Add other widgets here if needed
              ProductsPage(
                products: const [], // Pass your products list here
                controller: _scrollController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
