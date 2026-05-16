import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rincongaditano/screens/role_router_screen.dart';
import 'package:rincongaditano/services/product_service.dart';
import 'package:rincongaditano/services/user_service.dart';
import 'package:rincongaditano/providers/product_provider.dart';
import 'package:rincongaditano/providers/user_provider.dart';
import 'package:rincongaditano/services/category_service.dart';
import 'package:rincongaditano/providers/category_provider.dart';
import 'package:rincongaditano/providers/cart_provider.dart';
import 'package:rincongaditano/services/order_service.dart';
import 'package:rincongaditano/providers/order_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(UserService()),
        ),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProxyProvider<UserProvider, ProductProvider>(
          create: (context) => ProductProvider(ProductService(), null),
          update: (context, userProvider, productProvider) {
            final token = userProvider.activeUser?.token;
            return productProvider!..updateToken(token);
          },
        ),
        ChangeNotifierProxyProvider<UserProvider, CategoryProvider>(
          create: (context) => CategoryProvider(CategoryService(), null),
          update: (context, userProvider, categoryProvider) {
            final token = userProvider.activeUser?.token;
            return categoryProvider!..updateToken(token);
          },
        ),
        ChangeNotifierProxyProvider<UserProvider, OrderProvider>(
          create: (context) => OrderProvider(OrderService(), null),
          update: (context, userProvider, orderProvider) {
            final token = userProvider.activeUser?.token;
            return orderProvider!..updateToken(token);
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'El Rincón Gaditano',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange, useMaterial3: true),
      home: const RoleRouterScreen(),
    );
  }
}
