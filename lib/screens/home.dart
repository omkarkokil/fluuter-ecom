import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/Models/model.dart';
import 'package:test_app/constants/constant.dart';
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
    super.initState();

    fetchProducts();
    print(_scrollController);
    _scrollController.addListener(_scrollListener);
  }

  Future<void> fetchProducts({bool isNextPage = false}) async {
    try {
      final url = Uri.parse("$api/api/product/getAllproducts?page=$page");
      print(url);
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
      print(res);
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
      print("error: $e");
    }
  }

  // Scroll listener to detect when the user reaches the end
  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: foreground,
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.black54,
                        ),
                        hintText: 'Search...',
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: foreground,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black45,
                            width: 0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Add your carousel or other widgets here
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text("Categories",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    SizedBox(height: 100, child: Categories()),
                    const SizedBox(height: 10),
                    SizedBox(
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Products",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 20),
                                SizedBox(
                                  height: 400,
                                  child: ProductsPage(
                                    products: products,
                                    controller: _scrollController,
                                  ),
                                ),
                                if (isLoadingMore)
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Categories extends StatelessWidget {
  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Top',
      'image':
          'https://images.unsplash.com/photo-1484788984921-03950022c9ef?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bGFwdG9wfGVufDB8fDB8fHww'
    },
    {
      'name': 'Bottom',
      'image':
          'https://images.unsplash.com/photo-1642189198430-613ec31bb03e?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8ZWxlY3Rvbmljc3xlbnwwfHwwfHx8MA%3D%3D'
    },
    {
      'name': 'Attire',
      'image':
          'https://media.istockphoto.com/id/952839420/photo/home-appliancess-set-of-household-kitchen-technics-in-the-new-appartments-or-kitchen-e.webp?a=1&b=1&s=612x612&w=0&k=20&c=XpZfTiUu_HBPPUKlcuK9NVOAyNPizO6Ybiiagqomnqk='
    },
    {
      'name': 'Appliances',
      'image':
          'https://images.unsplash.com/photo-1509347528160-9a9e33742cdb?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8YXR0aXJlfGVufDB8fDB8fHww'
    },
    {
      'name': 'Electronics',
      'image':
          'https://images.unsplash.com/photo-1509347528160-9a9e33742cdb?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8YXR0aXJlfGVufDB8fDB8fHww'
    },
    {
      'name': 'Laptop/Tech',
      'image':
          'https://images.unsplash.com/photo-1484788984921-03950022c9ef?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bGFwdG9wfGVufDB8fDB8fHww'
    },
  ];

  Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      // Make the list horizontal
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            CircleAvatar(
              backgroundImage: NetworkImage(category['image']),
              radius: 30.0,
            ),
            Text(category['name'])
          ]),
        );
      },
    );
  }
}
