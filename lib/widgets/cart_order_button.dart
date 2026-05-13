import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rincongaditano/providers/cart_provider.dart';
import 'package:rincongaditano/providers/user_provider.dart';
import 'package:rincongaditano/providers/order_provider.dart';
import 'package:rincongaditano/screens/payment_screen.dart';

class CartOrderButton extends StatelessWidget {
  final UserProvider userProvider;
  final CartProvider cartProvider;
  final VoidCallback onNavigateToProfile;

  const CartOrderButton({
    super.key,
    required this.userProvider,
    required this.cartProvider,
    required this.onNavigateToProfile,
  });

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 5),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: orderProvider.isLoading
              ? null
              : () async {
                  if (userProvider.activeUser == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Debes iniciar sesión para poder realizar el pedido',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    onNavigateToProfile();
                  } else {
                    _showOptions(context);
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFB8C00),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 2,
          ),
          child: orderProvider.isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Text(
                  'Realizar pedido',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    String selectedDelivery = 'A domicilio';
    String selectedPayment = 'Tarjeta';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 24.0,
                bottom: 24.0 + MediaQuery.of(context).viewPadding.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Opciones de Pedido',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  // delivery / pick up
                  const Text(
                    'Método de entrega',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  RadioListTile<String>(
                    title: const Text('Reparto a Domicilio'),
                    value: 'A domicilio',
                    groupValue: selectedDelivery,
                    activeColor: const Color(0xFFFB8C00),
                    onChanged: (value) =>
                        setModalState(() => selectedDelivery = value!),
                  ),
                  RadioListTile<String>(
                    title: const Text('Recoger en Local'),
                    value: 'Recogida en local',
                    groupValue: selectedDelivery,
                    activeColor: const Color(0xFFFB8C00),
                    onChanged: (value) =>
                        setModalState(() => selectedDelivery = value!),
                  ),
                  const Divider(),
                  // payment method
                  const Text(
                    'Método de pago',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  RadioListTile<String>(
                    title: const Text('Tarjeta de Crédito / Débito'),
                    value: 'Tarjeta',
                    groupValue: selectedPayment,
                    activeColor: const Color(0xFFFB8C00),
                    onChanged: (value) =>
                        setModalState(() => selectedPayment = value!),
                  ),
                  RadioListTile<String>(
                    title: const Text('Efectivo'),
                    value: 'Efectivo',
                    groupValue: selectedPayment,
                    activeColor: const Color(0xFFFB8C00),
                    onChanged: (value) =>
                        setModalState(() => selectedPayment = value!),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(
                              deliveryType: selectedDelivery,
                              paymentMethod: selectedPayment,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFB8C00),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Continuar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
