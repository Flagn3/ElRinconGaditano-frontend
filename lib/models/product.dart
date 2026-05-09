class Product {
  int? id;
  String name;
  String description;
  double price;
  bool available;
  String category;
  String? image;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.available,
    required this.category,
    this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    price: (json['price'] as num?)?.toDouble() ?? 0.0,
    available: json['available'],
    category: json['category'],
    image: json['image'],
  );
}
