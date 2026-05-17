import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rincongaditano/providers/user_provider.dart';
import 'package:rincongaditano/screens/home_screen.dart';
import 'package:rincongaditano/screens/admin/admin_dashboard_screen.dart';

class RoleRouterScreen extends StatelessWidget {
  const RoleRouterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? userRole = context.select(
      (UserProvider provider) => provider.activeUser?.role,
    );

    if (userRole == 'ROLE_ADMIN') {
      return const AdminDashboardScreen();
    }

    return const HomeScreen();
  }
}
