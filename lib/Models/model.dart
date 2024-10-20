class Product {
  final String id;
  final String title;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
  });
}

class CartItem {
  final String id;
  final String title;
  final String desc;
  final double price;
  int quantity;
  final String imageUrl;

  CartItem(
      {required this.id,
      required this.price,
      required this.desc,
      required this.title,
      required this.quantity,
      required this.imageUrl});
}
