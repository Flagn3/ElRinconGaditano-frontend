import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rincongaditano/providers/cart_provider.dart';
import 'package:rincongaditano/providers/order_provider.dart';
import 'package:rincongaditano/providers/user_provider.dart';

class PaymentScreen extends StatefulWidget {
  final String deliveryType;
  final String paymentMethod;

  const PaymentScreen({
    super.key,
    required this.deliveryType,
    required this.paymentMethod,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isProcessingBank = false;

  final _cardController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  void _processPayment() async {
    if (widget.paymentMethod == 'Tarjeta' &&
        !_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isProcessingBank = true);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final userProvider = context.read<UserProvider>();
    final cartProvider = context.read<CartProvider>();
    final orderProvider = context.read<OrderProvider>();

    final user = userProvider.activeUser!;

    List<Map<String, dynamic>> orderItems = cartProvider.items.map((item) {
      return {'productId': item.product.id, 'amount': item.quantity};
    }).toList();

    bool success = await orderProvider.createOrder(
      user.id!,
      orderItems,
      widget.deliveryType,
    );

    if (!mounted) return;
    setState(() => _isProcessingBank = false);

    if (success) {
      cartProvider.clearCart();

      await userProvider.getById(user.id!, user.token!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pedido realizado, consulta su estado en tu perfil'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(orderProvider.errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    final subtotal = cartProvider.subtotal;
    final shippingCost = widget.deliveryType == 'A domicilio' ? 2.50 : 0.0;
    final totalFinal = subtotal + shippingCost;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pasarela de Pago',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isProcessingBank
          ? _buildLoadingView()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryCard(subtotal, shippingCost, totalFinal),
                    const SizedBox(height: 25),

                    if (widget.paymentMethod == 'Tarjeta') ...[
                      const Text(
                        'Datos de la Tarjeta',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _cardController,
                        keyboardType: TextInputType.number,
                        maxLength: 16,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Número de Tarjeta',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.credit_card),
                          counterText: '',
                        ),
                        validator: (value) => value == null || value.length < 16
                            ? 'Introduce los 16 dígitos'
                            : null,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _expiryController,
                              keyboardType: TextInputType.text,
                              maxLength: 5,
                              decoration: const InputDecoration(
                                labelText: 'MM/AA',
                                border: OutlineInputBorder(),
                                counterText: '',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Introduce la fecha';
                                }
                                final regExp = RegExp(r'^[0-9]{2}\/[0-9]{2}$');
                                if (!regExp.hasMatch(value)) {
                                  return 'Inválido';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: TextFormField(
                              controller: _cvvController,
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              decoration: const InputDecoration(
                                labelText: 'CVV',
                                border: OutlineInputBorder(),
                                counterText: '',
                              ),
                              validator: (value) =>
                                  value == null || value.length < 3
                                  ? 'Inválido'
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      _buildCashInfoCard(),
                    ],
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _processPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFB8C00),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          widget.paymentMethod == 'Tarjeta'
                              ? 'Pagar ${totalFinal.toStringAsFixed(2)}€'
                              : 'Confirmar Pedido',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSummaryCard(double subtotal, double shipping, double total) {
    return Card(
      color: Colors.orange.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Método: ${widget.paymentMethod}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Tipo: ${widget.deliveryType}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
                Text(
                  '${total.toStringAsFixed(2)}€',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFB8C00),
                  ),
                ),
              ],
            ),
            if (widget.deliveryType == 'A domicilio') ...[
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Comida:',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  Text(
                    '${subtotal.toStringAsFixed(2)}€',
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Envío:',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  Text(
                    '${shipping.toStringAsFixed(2)}€',
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCashInfoCard() {
    return Card(
      color: Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.payments, color: Colors.green, size: 30),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                'Pagarás en efectivo al recibir tu pedido o al recogerlo en el local.',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFFFB8C00)),
          SizedBox(height: 20),
          Text(
            'Conectando con la pasarela bancaria...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'No cierres la aplicación',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
