import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rincongaditano/models/order.dart';
import 'package:rincongaditano/providers/order_provider.dart';
import 'package:rincongaditano/providers/user_provider.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  bool _isCancelling = false;

  void _processCancel(int userId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Cancelar pedido?'),
        content: const Text(
          '¿Estás seguro de que deseas cancelar este pedido?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Volver', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Sí, cancelar',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isCancelling = true);

    await context.read<OrderProvider>().cancelOrder(widget.orderId, userId);

    if (!mounted) return;
    setState(() => _isCancelling = false);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<UserProvider>().activeUser?.id;

    final orderProvider = context.watch<OrderProvider>();
    final Order? order = orderProvider.orders.firstWhere(
      (o) => o.id == widget.orderId,
      orElse: () => orderProvider.orders.first,
    );

    if (order == null) {
      return const Scaffold(
        body: Center(child: Text('No se encontró el pedido')),
      );
    }

    final String status = order.status.toUpperCase();
    final bool isPending = status == 'PENDING';

    final String day = order.date.day.toString().padLeft(2, '0');
    final String month = order.date.month.toString().padLeft(2, '0');
    final String year = order.date.year.toString();
    final String formattedDate = "$day/$month/$year";

    double productsSubtotal = 0.0;
    for (var line in order.lines) {
      productsSubtotal += (line.unitPrice * line.amount);
    }
    bool isLocalPickup = (order.totalPrice - productsSubtotal).abs() < 0.1;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Pedido #${order.id}',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(order, formattedDate, isLocalPickup),
            const SizedBox(height: 20),
            _buildStatusCard(status),
            const SizedBox(height: 25),
            const Text(
              'Productos pedidos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            _buildProductsList(order),
            const SizedBox(height: 25),
            _buildPriceSummary(order, productsSubtotal, isLocalPickup),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: isPending && userId != null
          ? SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade200, width: 1),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: _isCancelling
                        ? null
                        : () => _processCancel(userId),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      foregroundColor: Colors.red,
                    ),
                    child: _isCancelling
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.red,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Cancelar Pedido',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildHeaderCard(Order order, String date, bool isLocalPickup) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(
              Icons.receipt_long_rounded,
              color: Color(0xFFFB8C00),
              size: 30,
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ref: #${order.id}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Realizado el $date',
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
              ],
            ),
            const Spacer(),
            Icon(
              isLocalPickup ? Icons.storefront : Icons.local_shipping_outlined,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(String status) {
    Color statusColor = Colors.orange;
    String statusText = 'Pendiente de aceptación';

    if (status == 'COMPLETED') {
      statusColor = Colors.green;
      statusText = 'Pedido Entregado';
    } else if (status == 'CANCELLED') {
      statusColor = Colors.red;
      statusText = 'Pedido Cancelado';
    } else if (status == 'ACCEPTED') {
      statusColor = Colors.blue;
      statusText = 'Pedido Aceptado en Cocina';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: statusColor, radius: 6),
          const SizedBox(width: 12),
          Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList(Order order) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: order.lines.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, color: Color(0xFFF5F5F5)),
        itemBuilder: (context, index) {
          final line = order.lines[index];
          final String productName = line.product.name;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${line.amount} x ${line.unitPrice.toStringAsFixed(2)}€',
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${(line.unitPrice * line.amount).toStringAsFixed(2)}€',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPriceSummary(Order order, double subtotal, bool isLocalPickup) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal Comida:',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                Text(
                  '${subtotal.toStringAsFixed(2)}€',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tipo de entrega:',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                Text(
                  isLocalPickup
                      ? 'Recogida (0.00€)'
                      : 'Envío a Domicilio (2.50€)',
                  style: TextStyle(
                    fontSize: 14,
                    color: isLocalPickup ? Colors.green : Colors.black87,
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
                const Text(
                  'Total General:',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
