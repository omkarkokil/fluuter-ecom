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

class Products {
  final String id;
  final String name;
  final String desc;
  final double price;
  final List<String> img;
  final String category;
  final int stock;

  Products({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.img,
    required this.category,
    required this.stock,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['_id'],
      name: json['name'],
      desc: json['desc'],
      price: (json['price'] as num).toDouble(),
      img: List<String>.from(json['img']), // Cast the list of images
      category: json['category'],
      stock: json['stock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'desc': desc,
      'price': price,
      'img': img,
      'category': category,
      'stock': stock,
    };
  }
}
