import 'package:flutter/material.dart';
import 'package:test_app/Models/model.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get cartItems => _cartItems;

  void removeItem(String title) {
    _cartItems.remove(title);
    notifyListeners();
  }

  double totalAmount() {
    double total = 0;
    _cartItems.forEach((key, cartItem) {
      total += cartItem.price.toInt() * cartItem.quantity;
    });
    return total;
  }

  void incremrentItem(String title) {
    _cartItems.update(
        title,
        (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              desc: existingCartItem.desc,
              quantity: existingCartItem.quantity + 1, // Add quantity
              price: existingCartItem.price,
              imageUrl: existingCartItem.imageUrl,
            ));
    notifyListeners();
  }

  void decrementItem(String title) {
    _cartItems.update(
      title,
      (existingCartItem) {
        // If updated quantity is 0, remove the item
        int updatedQuantity = existingCartItem.quantity;
        if (existingCartItem.quantity > 1) {
          updatedQuantity =
              existingCartItem.quantity - 1; // Remove the item from the cart
        }

        // Return a new CartItem with updated quantity
        return CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          desc: existingCartItem.desc,
          quantity: updatedQuantity,
          price: existingCartItem.price,
          imageUrl: existingCartItem.imageUrl,
        );
      },
    );

    notifyListeners(); // Notify listeners for state change
  }

  void addItem(String id, String title, double price, int quantity,
      String imageUrl, String desc) {
    if (_cartItems.containsKey(id)) {
      // Update the quantity of the existing item
      _cartItems.update(
          id,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                desc: existingCartItem.desc,
                quantity: existingCartItem.quantity + quantity, // Add quantity
                price: existingCartItem.price,
                imageUrl: existingCartItem.imageUrl,
              ));
    } else {
      // Add new item to the cart
      _cartItems[id] = CartItem(
          id: id,
          desc: desc,
          title: title,
          quantity: quantity,
          price: price,
          imageUrl: imageUrl);
    }
    notifyListeners(); // Notify listeners for state change
  }

  void clearCart() {
    _cartItems = {};
    notifyListeners();
  }
}
