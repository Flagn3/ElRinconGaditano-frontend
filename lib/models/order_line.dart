import 'package:rincongaditano/models/product.dart';

class OrderLine {
  int? id;
  Product product;
  int amount;
  double unitPrice;

  OrderLine({
    this.id,
    required this.product,
    required this.amount,
    required this.unitPrice,
  });

  factory OrderLine.fromJson(Map<String, dynamic> json) {
    return OrderLine(
      id: json['id'],
      product: Product.fromJson(json['product']),
      amount: json['amount'] ?? 0,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
