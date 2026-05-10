import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rincongaditano/providers/category_provider.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().getAllCategories();
    });
  }

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

            Expanded(
              child: Consumer<CategoryProvider>(
                builder: (context, categoryProvider, child) {
                  if (categoryProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFFFB8C00),
                        ),
                      ),
                    );
                  }

                  if (categoryProvider.errorMessage.isNotEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.cloud_off,
                              size: 60,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'No se han podido cargar las categorías.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              categoryProvider.errorMessage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 15),
                            ElevatedButton(
                              onPressed: () =>
                                  categoryProvider.getAllCategories(),
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

                  if (categoryProvider.categories.isEmpty) {
                    return const Center(
                      child: Text(
                        'No hay categorías disponibles.',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    itemCount: categoryProvider.categories.length,
                    itemBuilder: (context, index) {
                      final category = categoryProvider.categories[index];
                      // default image if image = null
                      final String imageUrl =
                          category.image ??
                          'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600';

                      return CategoryCard(
                        name: category.name,
                        imageUrl: imageUrl,
                        onTap: () {
                          print(
                            'Categoría: ${category.name} ID: ${category.id}',
                          );
                          // TODO go to products by category selected
                        },
                      );
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
                CircleAvatar(
                  radius: 15,
                  backgroundImage: const AssetImage("assets/images/points.jpg"),
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
