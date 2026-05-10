import 'package:flutter/material.dart';
import 'package:rincongaditano/providers/cart_provider.dart';

class CartSummary extends StatelessWidget {
  final CartProvider cartProvider;

  const CartSummary({super.key, required this.cartProvider});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E0E0)),
      ),
      child: Column(
        children: [
          _buildRow(
            'Total pedido:',
            '${cartProvider.subtotal.toStringAsFixed(2)} €',
            isBold: true,
          ),
          const SizedBox(height: 8),
          _buildRow(
            'Gastos de envío:',
            '${cartProvider.deliveryCost.toStringAsFixed(2)} €',
          ),
          const Divider(height: 24, thickness: 1, color: Color(0xFFD3D3D3)),
          _buildRow(
            'Total a pagar:',
            '${cartProvider.total.toStringAsFixed(2)} €',
            isBold: true,
            fontSize: 22,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value, {
    bool isBold = false,
    double fontSize = 16,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'Inter',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}
