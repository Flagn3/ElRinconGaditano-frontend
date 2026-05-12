import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rincongaditano/providers/cart_provider.dart';
import 'package:rincongaditano/providers/user_provider.dart';
import 'package:rincongaditano/widgets/cart_header.dart';
import 'package:rincongaditano/widgets/cart_item_card.dart';
import 'package:rincongaditano/widgets/cart_summary.dart';
import 'package:rincongaditano/widgets/empty_cart_view.dart';

class CartScreen extends StatelessWidget {
  final VoidCallback onNavigateToProfile;

  const CartScreen({super.key, required this.onNavigateToProfile});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CartHeader(),
            const SizedBox(height: 10),
            Expanded(
              child: cartProvider.items.isEmpty
                  ? const EmptyCartView()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      itemCount: cartProvider.items.length,
                      itemBuilder: (context, index) {
                        return CartItemCard(
                          item: cartProvider.items[index],
                          cartProvider: cartProvider,
                        );
                      },
                    ),
            ),

            if (cartProvider.items.isNotEmpty)
              CartSummary(cartProvider: cartProvider),

            if (cartProvider.items.isNotEmpty)
              _buildOrderButton(context, userProvider, cartProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderButton(
    BuildContext context,
    UserProvider userProvider,
    CartProvider cartProvider,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 5),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: () {
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
              print('Total pedido: ${cartProvider.total}€'); //TODO create order
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
          child: const Text(
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
