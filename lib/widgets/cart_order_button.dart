import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rincongaditano/providers/cart_provider.dart';
import 'package:rincongaditano/providers/user_provider.dart';
import 'package:rincongaditano/providers/order_provider.dart';

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
                    final user = userProvider.activeUser!;

                    List<Map<String, dynamic>> orderItems = cartProvider.items
                        .map((item) {
                          return {
                            'productId': item.product.id,
                            'amount': item.quantity,
                          };
                        })
                        .toList();

                    bool success = await context
                        .read<OrderProvider>()
                        .createOrder(user.id!, orderItems);

                    if (context.mounted) {
                      if (success) {
                        cartProvider.clearCart();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('¡Pedido realizado con éxito!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(orderProvider.errorMessage),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
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
}
