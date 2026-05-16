import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rincongaditano/providers/user_provider.dart';
import 'package:rincongaditano/screens/home_screen.dart';
import 'package:rincongaditano/screens/admin/admin_dashboard_screen.dart';

class RoleRouterScreen extends StatelessWidget {
  const RoleRouterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    if (userProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.orange)),
      );
    }

    final user = userProvider.activeUser;

    if (user == null || user.role == 'ROLE_USER') {
      return const HomeScreen();
    }

    if (user.role == 'ROLE_ADMIN') {
      return const AdminDashboardScreen();
    }

    return const HomeScreen();
  }
}
