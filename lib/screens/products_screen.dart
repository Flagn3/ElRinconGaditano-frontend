import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rincongaditano/providers/user_provider.dart';
import 'package:rincongaditano/widgets/category_card.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();

  // categories list
  final List<Map<String, String>> _categories = [
    {
      'name': 'Bocadillos',
      'image':
          'https://images.unsplash.com/photo-1509722747041-616f39b57569?w=600&auto=format&fit=crop',
    },
    {
      'name': 'Hamburguesas',
      'image':
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&auto=format&fit=crop',
    },
    {
      'name': 'Frituras',
      'image':
          'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=600&auto=format&fit=crop',
    },
    {
      'name': 'Sándwiches',
      'image':
          'https://images.unsplash.com/photo-1539252554453-80ab65ce3586?w=600&auto=format&fit=crop',
    },
    {
      'name': 'Bocadillos de Tortilla',
      'image':
          'https://images.unsplash.com/photo-1539252554453-80ab65ce3586?w=600&auto=format&fit=crop',
    },
    {
      'name': 'Platos Combinados',
      'image':
          'https://images.unsplash.com/photo-1539252554453-80ab65ce3586?w=600&auto=format&fit=crop',
    },
    {
      'name': 'Patatas Fritas',
      'image':
          'https://images.unsplash.com/photo-1539252554453-80ab65ce3586?w=600&auto=format&fit=crop',
    },
    {
      'name': 'Pizzas',
      'image':
          'https://images.unsplash.com/photo-1539252554453-80ab65ce3586?w=600&auto=format&fit=crop',
    },
    {
      'name': 'Salsas',
      'image':
          'https://images.unsplash.com/photo-1539252554453-80ab65ce3586?w=600&auto=format&fit=crop',
    },
    {
      'name': 'Bebidas',
      'image':
          'https://images.unsplash.com/photo-1539252554453-80ab65ce3586?w=600&auto=format&fit=crop',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // header
            _buildCustomHeader(),

            // button to search
            _buildSearchBar(),

            const SizedBox(height: 15),

            // categories
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return CategoryCard(
                    name: category['name']!,
                    imageUrl: category['image']!,
                    onTap: () {
                      print('Categoría: ${category['name']}');
                      // TODO go to productsByCategory
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // header widget
  Widget _buildCustomHeader() {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.activeUser;
    final String points = user != null ? '${user.points ?? 0}' : '0';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 100, height: 40),
          // logo
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(
                image: AssetImage("assets/images/rinconGaditanoLogo.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // points
          Container(
            width: 100,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFFB8C00), width: 1.5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  Icons.flag_circle, //TODO use flag image
                  color: Color(0xFFFB8C00),
                  size: 24,
                ),
                Text(
                  points,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // searcher
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: const Color(0xFFFB8C00),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.start,
          decoration: const InputDecoration(
            hintText: 'Buscador',
            hintStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 110), // TODO center
              child: Icon(Icons.search, color: Colors.white),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 10),
          ),
          onChanged: (value) {
            // TODO go to search
          },
        ),
      ),
    );
  }
}
