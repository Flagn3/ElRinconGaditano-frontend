import 'package:rincongaditano/models/order_line.dart';

class Order {
  int? id;
  DateTime date;
  String status;
  double totalPrice;
  List<OrderLine> lines;

  Order({
    this.id,
    required this.date,
    required this.status,
    required this.totalPrice,
    required this.lines,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final list = json['lines'] as List? ?? [];
    final orderLines = list.map((item) => OrderLine.fromJson(item)).toList();

    return Order(
      id: json['id'],
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      status: json['status'] ?? 'PENDING',
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      lines: orderLines,
    );
  }
}
