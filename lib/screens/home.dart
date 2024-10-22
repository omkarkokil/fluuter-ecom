import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/Models/model.dart';
import 'package:test_app/widgets/home/product_cart.dart';

class ImageData {
  final String url;
  final String title;
  ImageData({required this.url, required this.title});
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final List<ImageData> imageList = [
    ImageData(
        url:
            "https://images.unsplash.com/photo-1635514569146-9a9607ecf303?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Z2FtZXN8ZW58MHx8MHx8fDA%3D",
        title: "Buy 1 Get 1 Free"),
    ImageData(
        url:
            "https://plus.unsplash.com/premium_photo-1661964205360-b0621b5a9366?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8c3RvcmV8ZW58MHx8MHx8fDA%3D",
        title: "Best Shop in the world"),
    ImageData(
        url:
            "https://images.unsplash.com/photo-1464226184884-fa280b87c399?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfHx8MA%3D%3D",
        title: "Now Grocessary at your Doorstep"),
  ];

  List<Products> products = []; // List to store products
  bool isLoading = false; // Variable to track loading state
  bool isLoadingMore = false; // Variable to track loading more products
  int page = 1; // Page counter for pagination
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0);

  @override
  void initState() {
    print(_scrollController);
    super.initState();
    fetchProducts(); // Load initial data
    _scrollController.addListener(_scrollListener);
  }

  Future<void> fetchProducts({bool isNextPage = false}) async {
    final url = Uri.parse(
        "http://192.168.1.6:5000/api/product/getAllproducts?page=$page");
    try {
      if (!isNextPage) {
        setState(() {
          isLoading = true; // Show loading indicator for first load
        });
      } else {
        setState(() {
          isLoadingMore = true; // Show loading indicator for more data
        });
      }

      print(isNextPage);

      final res = await http.get(url);
      final Map<String, dynamic> jsonResponse = json.decode(res.body);
      List<dynamic> jsonData = jsonResponse['products'];

      if (res.statusCode == 200) {
        setState(() {
          if (isNextPage) {
            // Append the new products to the existing list
            products.addAll(
                jsonData.map((json) => Products.fromJson(json)).toList());
          } else {
            // Set the initial data
            products = jsonData.map((json) => Products.fromJson(json)).toList();
          }
          isLoading = false;
          isLoadingMore = false;
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isLoadingMore = false;
      });
      print(e);
    }
  }

  // Scroll listener to detect when the user reaches the end
  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      print("object");
      page++; // Increment the page number
      Future(() =>
          fetchProducts(isNextPage: true)); // Fetch the next page of products
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 200, // Adjust height as needed
              viewportFraction: 1.0, // Full-width images
              enlargeCenterPage: false, // Disable zoom effect
              autoPlay: true, // Auto-play the carousel
            ),
            items: imageList.map((item) {
              return Stack(
                children: [
                  ClipRRect(
                    child: Image.network(
                      item.url,
                      fit: BoxFit.cover,
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                      color:
                          Colors.black.withOpacity(0.5), // Darken with opacity
                    ),
                  ),
                  Positioned(
                    left: 45,
                    top: 40,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      item.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 24),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Products",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: ProductsPage(
                            products: products,
                            controller: _scrollController,
                          ),
                        ),
                        if (isLoadingMore) // Show loading indicator at the bottom
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                      ],
                    ),
            ),
          )
        ],
      ),
    ));
  }
}
