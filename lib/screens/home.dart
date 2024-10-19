import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:test_app/widgets/home/product_cart.dart';

class ImageData {
  final String url;
  final String title;
  ImageData({required this.url, required this.title});
}

class HomeWidget extends StatelessWidget {
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

  HomeWidget({super.key});

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
                    color: Colors.black.withOpacity(0.5), // Darken with opacity
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 40,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    item.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 30),
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
        const ProductItems(),
      ],
    )));
  }
}
