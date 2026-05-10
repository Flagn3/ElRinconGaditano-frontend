import 'package:flutter/material.dart';
import 'package:rincongaditano/screens/category_products_screen.dart';
import 'products_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  String? _selectedCategory;

  Widget _buildProductsTab() {
    if (_selectedCategory == null) {
      return ProductsScreen(
        onCategorySelected: (categoryName) {
          setState(() {
            _selectedCategory = categoryName;
          });
        },
      );
    } else {
      return CategoryProductsScreen(
        categoryName: _selectedCategory!,
        onBack: () {
          setState(() {
            _selectedCategory = null;
          });
        },
      );
    }
  }
  /*
  final List<Widget> _screens = [
    const ProductsScreen(),
    const Scaffold(body: Center(child: Text('Carrito'))),
    const Scaffold(body: Center(child: Text('Perfil'))),
  ];*/

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _buildProductsTab(),
      const Scaffold(body: Center(child: Text('Carrito'))),
      const Scaffold(body: Center(child: Text('Perfil'))),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            activeIcon: Icon(Icons.restaurant_menu_outlined),
            label: 'Productos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            activeIcon: Icon(Icons.shopping_cart_outlined),
            label: 'Carrito',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            activeIcon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
