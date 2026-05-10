import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rincongaditano/providers/product_provider.dart';
import 'package:rincongaditano/widgets/product_card.dart';
import 'package:rincongaditano/models/product.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String categoryName;
  final VoidCallback onBack;
  final ValueChanged<Product> onProductSelected;

  const CategoryProductsScreen({
    super.key,
    required this.categoryName,
    required this.onBack,
    required this.onProductSelected,
  });

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().getAvailableByCategory(
        widget.categoryName,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        backgroundColor: const Color(0xFFFB8C00),
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          onPressed: widget.onBack,
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFB8C00)),
              ),
            );
          }

          if (productProvider.errorMessage.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off, size: 60, color: Colors.grey),
                    const SizedBox(height: 10),
                    const Text(
                      'No se han podido cargar los productos.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () => productProvider.getAvailableByCategory(
                        widget.categoryName,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFB8C00),
                      ),
                      child: const Text(
                        'Reintentar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (productProvider.products.isEmpty) {
            return Center(
              child: Text(
                'No hay productos en esta categoría',
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            itemCount: productProvider.products.length,
            itemBuilder: (context, index) {
              final product = productProvider.products[index];

              return GestureDetector(
                onTap: () {
                  widget.onProductSelected(product); //go to product detail
                },
                child: ProductCard(
                  product: product,
                  onAddTap: () {
                    // TODO add to chart when press the button
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Producto añadido al carrito'),
                        duration: const Duration(seconds: 1),
                        backgroundColor: const Color(0xFFFB8C00),
                      ),
                    );
                  },
                ),
              );
              /*
              return ProductCard(
                product: product,
                onAddTap: () {
                  // TODO add to chart when press the button
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Producto añadido al carrito'),
                      duration: const Duration(seconds: 1),
                      backgroundColor: const Color(0xFFFB8C00),
                    ),
                  );
                },
              );*/
            },
          );
        },
      ),
    );
  }
}
