import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rincongaditano/models/order.dart';
import 'package:rincongaditano/providers/order_provider.dart';
import 'package:rincongaditano/providers/user_provider.dart';

class OrdersHistoryScreen extends StatefulWidget {
  final bool showOnlyLast;

  const OrdersHistoryScreen({super.key, this.showOnlyLast = false});

  @override
  State<OrdersHistoryScreen> createState() => _OrdersHistoryScreenState();
}

class _OrdersHistoryScreenState extends State<OrdersHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<UserProvider>().activeUser?.id;
      if (userId != null) {
        context.read<OrderProvider>().getOrdersByUser(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();

    final orders = widget.showOnlyLast
        ? (orderProvider.orders.isNotEmpty ? [orderProvider.orders.first] : [])
        : orderProvider.orders;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.showOnlyLast ? 'Estado de tu Último Pedido' : 'Mis Pedidos',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: orderProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFB8C00)),
            )
          : orderProvider.errorMessage.isNotEmpty
          ? Center(
              child: Text(
                orderProvider.errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            )
          : orders.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final Order order = orders[index];
                return _buildOrderCard(order);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'No hay pedidos registrados',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    final String day = order.date.day.toString().padLeft(2, '0');
    final String month = order.date.month.toString().padLeft(2, '0');
    final String year = order.date.year.toString();
    final String formattedDate = "$day/$month/$year";

    int totalArticles = 0;
    for (var line in order.lines) {
      totalArticles += line.amount;
    }

    double productsSubtotal = 0.0;
    if (order.lines != null) {
      for (var line in order.lines) {
        productsSubtotal += (line.unitPrice * line.amount);
      }
    }

    bool isLocalPickup = (order.totalPrice - productsSubtotal).abs() < 0.1;
    double shippingCost = isLocalPickup ? 0.0 : 2.50;

    final String status = order.status.toUpperCase();
    Color statusColor = Colors.orange;
    String statusText = 'Pendiente';

    if (status == 'COMPLETED') {
      statusColor = Colors.green;
      statusText = 'Entregado';
    } else if (status == 'CANCELLED') {
      statusColor = Colors.red;
      statusText = 'Cancelado';
    } else if (status == 'ACCEPTED') {
      statusColor = Colors.blue;
      statusText = 'Aceptado';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey[700],
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Contenido:',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  totalArticles == 1
                      ? '1 artículo'
                      : '$totalArticles artículos',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tipo de entrega:',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  isLocalPickup ? 'Recogida en Local' : 'Envío a Domicilio',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(height: 1, color: Color(0xFFF5F5F5)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ref: #${order.id}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                    fontFamily: 'Inter',
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      'Total ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      '${order.totalPrice.toStringAsFixed(2)}€',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFB8C00),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
