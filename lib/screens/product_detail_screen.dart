import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rincongaditano/models/product.dart';
import 'package:rincongaditano/providers/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final VoidCallback onBack;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.onBack,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  void _increment() {
    if (_quantity < 30) {
      setState(() {
        _quantity++;
      });
    }
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double totalPrice = widget.product.price * _quantity;
    final String imageUrl = widget.product.image ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.product.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        backgroundColor: const Color(0xFFFB8C00),
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 250,
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.fastfood,
                              size: 80,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // name
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 8),

                    // price
                    Text(
                      '${widget.product.price.toStringAsFixed(2)}€ / unidad',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFB8C00),
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 15),

                    Divider(color: Colors.grey[200], thickness: 1),
                    const SizedBox(height: 15),

                    // description
                    const Text(
                      'Descripción',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.product.description.isNotEmpty
                          ? widget.product.description
                          : 'Este producto no tiene descripción',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                        height: 1.4,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 30),

                    // select quantity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildQuantityButton(
                          icon: Icons.remove,
                          onTap: _quantity > 1 ? _decrement : null,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Text(
                            '$_quantity',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        _buildQuantityButton(
                          icon: Icons.add,
                          onTap: _quantity < 30 ? _increment : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // add to chart button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<CartProvider>().addProduct(
                      widget.product,
                      quantity: _quantity,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Producto añadido al carrito'),
                        duration: const Duration(seconds: 2),
                        backgroundColor: const Color(0xFFFB8C00),
                      ),
                    );
                    widget.onBack();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFB8C00),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'AÑADIR POR ${totalPrice.toStringAsFixed(2)}€',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // buttons to increment/decrement quantity
  Widget _buildQuantityButton({required IconData icon, VoidCallback? onTap}) {
    final bool isEnabled = onTap != null;
    return Material(
      color: isEnabled ? Colors.grey[100] : Colors.grey[50],
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Icon(
            icon,
            color: isEnabled ? const Color(0xFFFB8C00) : Colors.grey[300],
            size: 24,
          ),
        ),
      ),
    );
  }
}
