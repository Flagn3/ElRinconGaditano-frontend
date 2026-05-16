import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rincongaditano/models/product.dart';
import 'package:rincongaditano/providers/product_provider.dart';
import 'package:rincongaditano/widgets/admin_product_card.dart';
import 'package:rincongaditano/widgets/product_form.dart';

class AdminProductScreen extends StatefulWidget {
  const AdminProductScreen({super.key});

  @override
  State<AdminProductScreen> createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends State<AdminProductScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().getAllProducts();
    });
  }

  void _openProductForm({Product? product}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductForm(product: product),
    );
  }

  void _confirmDelete(Product product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Producto'),
        content: Text(
          '¿Seguro que deseas eliminar "${product.name}" de la carta? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && product.id != null) {
      if (!mounted) return;
      final provider = context.read<ProductProvider>();
      await provider.deleteProduct(product.id!);

      if (!mounted) return;
      if (provider.errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Producto eliminado con éxito'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Menú de Productos',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFB8C00),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: productProvider.isLoading && productProvider.products.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : productProvider.products.isEmpty
          ? const Center(child: Text('Aún no hay ningún producto'))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 110),
              itemCount: productProvider.products.length,
              itemBuilder: (context, index) {
                final product = productProvider.products[index];

                return Dismissible(
                  key: Key(product.id.toString()),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) async {
                    _confirmDelete(product);
                    return false;
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade600,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  child: AdminProductCard(
                    product: product,
                    onTap: () => _openProductForm(product: product),
                    onAvailableChanged: (newValue) async {
                      if (product.id != null) {
                        await context.read<ProductProvider>().switchAvailable(
                          product.id!,
                        );
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openProductForm(),
        backgroundColor: const Color(0xFFFB8C00),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Nuevo Producto',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
