import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/Models/model.dart';

class WishlistProvider with ChangeNotifier {
  final Map<String, Products> _wishlistItems = {};

  Map<String, Products> get wishlistItems => _wishlistItems;

  WishlistProvider() {
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final String? wishlistJson = prefs.getString('wishlistItems');

    if (wishlistJson != null) {
      final Map<String, dynamic> decodedWishlist =
          json.decode(wishlistJson) as Map<String, dynamic>;
      decodedWishlist.forEach((key, value) {
        _wishlistItems[key] = Products.fromJson(value);
      });
      notifyListeners();
    }
  }

  void removeItem(String name) {
    _wishlistItems.remove(name);
    _saveWishlist();
    notifyListeners();
  }

  void mutateWishList(Products items) {
    if (_wishlistItems.containsKey(items.name)) {
      _wishlistItems.remove(items.name);
    } else {
      _wishlistItems[items.name] = items; // Store the entire product
    }
    _saveWishlist();
    notifyListeners(); // Notify listeners for state change
  }

  Future<void> _saveWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final String wishlistJson = json.encode(
      _wishlistItems.map((key, value) => MapEntry(key, value.toJson())),
    );
    await prefs.setString('wishlistItems', wishlistJson);
  }
}
