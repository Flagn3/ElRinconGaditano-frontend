import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rincongaditano/providers/order_provider.dart';
import 'package:rincongaditano/models/order.dart';
import 'package:rincongaditano/screens/admin/order_detail_admin_screen.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().getAllOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final orders = orderProvider.orders;

    final pendingOrders = orders
        .where((o) => o.status.toUpperCase() == 'PENDING')
        .toList();
    final acceptedOrders = orders
        .where((o) => o.status.toUpperCase() == 'ACCEPTED')
        .toList();
    final historyOrders = orders
        .where(
          (o) =>
              o.status.toUpperCase() == 'COMPLETED' ||
              o.status.toUpperCase() == 'CANCELLED',
        )
        .toList();

    pendingOrders.sort((a, b) => b.date.compareTo(a.date));
    acceptedOrders.sort((a, b) => b.date.compareTo(a.date));
    historyOrders.sort((a, b) => b.date.compareTo(a.date));

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: const Text(
            'Gestión de Pedidos',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Inter',
            ),
          ),
          backgroundColor: const Color(0xFFFB8C00),
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Color(0xFFFFCC80),
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(Icons.notifications_active_rounded),
                text: 'Pendientes',
              ),
              Tab(icon: Icon(Icons.soup_kitchen_rounded), text: 'Aceptados'),
              Tab(icon: Icon(Icons.history_rounded), text: 'Historial'),
            ],
          ),
        ),
        body: orderProvider.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.orange),
              )
            : TabBarView(
                children: [
                  _buildOrdersList(
                    pendingOrders,
                    orderProvider,
                    isPendingTab: true,
                  ),
                  _buildOrdersList(
                    acceptedOrders,
                    orderProvider,
                    isAcceptedTab: true,
                  ),
                  _buildOrdersList(historyOrders, orderProvider),
                ],
              ),
      ),
    );
  }

  Widget _buildOrdersList(
    List<Order> orderList,
    OrderProvider provider, {
    bool isPendingTab = false,
    bool isAcceptedTab = false,
  }) {
    if (orderList.isEmpty) {
      return RefreshIndicator(
        color: Colors.orange,
        onRefresh: () async {
          await provider.getAllOrders();
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 100),
            Center(
              child: Text(
                'No hay pedidos en esta sección',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      color: Colors.orange,
      onRefresh: () async {
        await provider.getAllOrders();
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: orderList.length,
        itemBuilder: (context, index) {
          final order = orderList[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      OrderDetailAdminScreen(orderId: order.id!),
                ),
              );
            },
            child: _buildOrderCard(
              order,
              provider,
              isPendingTab,
              isAcceptedTab,
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(
    Order order,
    OrderProvider provider,
    bool isPendingTab,
    bool isAcceptedTab,
  ) {
    int totalArticles = order.lines.length;

    String formatedDate =
        "${order.date.day.toString().padLeft(2, '0')}/${order.date.month.toString().padLeft(2, '0')}/${order.date.year} ${order.date.hour.toString().padLeft(2, '0')}:${order.date.minute.toString().padLeft(2, '0')}";

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pedido #${order.id}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  '${order.totalPrice.toStringAsFixed(2)}€',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFFFB8C00),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            const Divider(height: 20, color: Color(0xFFF5F5F5)),

            Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  formatedDate,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.shopping_bag_outlined,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  'Contiene $totalArticles productos diferentes',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),

            if (!isPendingTab && !isAcceptedTab) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: order.status.toUpperCase() == 'COMPLETED'
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  order.status.toUpperCase() == 'COMPLETED'
                      ? 'COMPLETADO'
                      : 'CANCELADO',
                  style: TextStyle(
                    color: order.status.toUpperCase() == 'COMPLETED'
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 14),

            if (isPendingTab)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        bool confirmar = await _showConfirmDialog(
                          context,
                          'Rechazar pedido',
                          '¿Seguro que deseas rechazar el pedido #${order.id}?',
                          Colors.red,
                        );
                        if (confirmar) {
                          provider.updateOrderStatus(order.id!, 'CANCELLED');
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Rechazar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        bool confirmar = await _showConfirmDialog(
                          context,
                          'Aceptar pedido',
                          '¿Quieres enviar el pedido #${order.id} a la cocina?',
                          Colors.green,
                        );
                        if (confirmar) {
                          provider.updateOrderStatus(order.id!, 'ACCEPTED');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Aceptar'),
                    ),
                  ),
                ],
              ),

            if (isAcceptedTab)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    bool confirmar = await _showConfirmDialog(
                      context,
                      'Entregar pedido',
                      '¿Confirmas que el pedido #${order.id} ha sido entregado?',
                      Colors.blue,
                    );
                    if (confirmar) {
                      provider.updateOrderStatus(order.id!, 'COMPLETED');
                    }
                  },
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  label: const Text('Marcar como Entregado'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showConfirmDialog(
    BuildContext context,
    String title,
    String message,
    Color confirmColor,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        content: Text(message, style: const TextStyle(fontFamily: 'Inter')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Volver',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Confirmar',
              style: TextStyle(
                color: confirmColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
