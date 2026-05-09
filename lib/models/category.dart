class Category {
  int? id;
  String name;
  String? image;

  Category({this.id, required this.name, this.image});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'],
    name: json['name'],
    image:
        json['image'] ??
        'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600',
  );
}
