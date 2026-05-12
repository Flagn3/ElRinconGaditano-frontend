import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rincongaditano/providers/cart_provider.dart';
import 'package:rincongaditano/providers/user_provider.dart';
import 'package:rincongaditano/widgets/cart_header.dart';
import 'package:rincongaditano/widgets/cart_item_card.dart';
import 'package:rincongaditano/widgets/cart_summary.dart';
import 'package:rincongaditano/widgets/empty_cart_view.dart';
import 'package:rincongaditano/widgets/cart_order_button.dart';

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
              CartOrderButton(
                userProvider: userProvider,
                cartProvider: cartProvider,
                onNavigateToProfile: onNavigateToProfile,
              ),
          ],
        ),
      ),
    );
  }
}
