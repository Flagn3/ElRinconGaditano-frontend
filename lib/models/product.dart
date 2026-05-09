class Product {
  int? id;
  String name;
  String description;
  double price;
  bool available;
  String categoryName;
  String? image;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.available,
    required this.categoryName,
    this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final categoryMap = json['category'] as Map<String, dynamic>?;
    final name = categoryMap != null
        ? categoryMap['name'] as String
        : 'Sin categoría';

    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      available: json['available'],
      categoryName: name,
      image: json['image'],
    );
  }
}
