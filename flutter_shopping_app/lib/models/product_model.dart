class Product {
  final int id;
  final String name;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl = '',
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unnamed Product',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '', // ค่า default สำหรับ imageUrl
    );
  }
}
