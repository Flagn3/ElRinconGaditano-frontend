import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rincongaditano/providers/cart_provider.dart';
import 'package:rincongaditano/screens/cart_screen.dart';
import 'package:rincongaditano/screens/category_products_screen.dart';
import 'package:rincongaditano/screens/product_detail_screen.dart';
import 'package:rincongaditano/screens/profile_screen.dart';
import 'products_screen.dart';
import 'package:rincongaditano/models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  String? _selectedCategory;
  Product? _selectedProduct;

  // select which screen show in producs tab
  Widget _buildProductsTab() {
    if (_selectedProduct != null) {
      return ProductDetailScreen(
        product: _selectedProduct!,
        onBack: () {
          setState(() {
            _selectedProduct = null;
          });
        },
      );
    } else if (_selectedCategory != null) {
      return CategoryProductsScreen(
        categoryName: _selectedCategory!,
        onBack: () {
          setState(() {
            _selectedCategory = null;
          });
        },
        onProductSelected: (product) {
          setState(() {
            _selectedProduct = product;
          });
        },
      );
    } else {
      return ProductsScreen(
        onCategorySelected: (categoryName) {
          setState(() {
            _selectedCategory = categoryName;
          });
        },
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final int totalItems = cartProvider.items.length;

    final List<Widget> screens = [
      _buildProductsTab(),
      CartScreen(onNavigateToProfile: () => _onItemTapped(2)),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            activeIcon: Icon(Icons.restaurant_menu_outlined),
            label: 'Productos',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: totalItems > 0,
              backgroundColor: const Color(0xFFFB8C00),
              label: Text(
                '$totalItems',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  fontFamily: 'Inter',
                ),
              ),
              child: const Icon(Icons.shopping_cart),
            ),

            activeIcon: Badge(
              isLabelVisible: totalItems > 0,
              backgroundColor: const Color(0xFFFB8C00),
              label: Text(
                '$totalItems',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  fontFamily: 'Inter',
                ),
              ),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            label: 'Carrito',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            activeIcon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
