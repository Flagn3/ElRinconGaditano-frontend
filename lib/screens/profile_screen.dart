import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rincongaditano/models/user.dart';
import 'package:rincongaditano/providers/user_provider.dart';
import 'package:rincongaditano/screens/auth/login_screen.dart';
import 'package:rincongaditano/screens/auth/register_screen.dart';
import 'package:rincongaditano/screens/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showLoginScreen = true;

  String _getAppBarTitle(User? user) {
    if (user != null) {
      return 'Mi Perfil';
    }
    return _showLoginScreen ? 'Iniciar Sesión' : 'Crear Cuenta';
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.activeUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(user),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: user != null
            ? _buildUserProfileView(context, userProvider)
            : _buildAuthView(),
      ),
    );
  }

  Widget _buildAuthView() {
    if (_showLoginScreen) {
      return LoginScreen(
        onNavigateToRegister: () => setState(() => _showLoginScreen = false),
      );
    } else {
      return RegisterScreen(
        onNavigateToLogin: () => setState(() => _showLoginScreen = true),
      );
    }
  }

  Widget _buildUserProfileView(
    BuildContext context,
    UserProvider userProvider,
  ) {
    final user = userProvider.activeUser!;
    final String fullName = '${user.name ?? ''} ${user.secondName ?? ''}'
        .trim();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage("assets/images/rinconGaditanoLogo.jpg"),
          ),
          const SizedBox(height: 16),
          Text(
            fullName.isNotEmpty ? fullName : '',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          Text(
            user.email ?? '',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 30),

          // points card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFB8C00),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFB8C00).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tus Cubanitos:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${user.points ?? 0}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(width: 14),
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage("assets/images/points.jpg"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                _buildMenuButton(
                  icon: Icons.delivery_dining_outlined,
                  title: 'Estado del último pedido',
                  onTap: () {
                    // TODO
                    print('Ver último pedido');
                  },
                ),
                _buildMenuButton(
                  icon: Icons.history,
                  title: 'Historial de pedidos',
                  onTap: () {
                    // TODO
                    print('Ver historial de pedidos');
                  },
                ),
                _buildMenuButton(
                  icon: Icons.edit_outlined,
                  title: 'Editar perfil',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuButton(
                  icon: Icons.delete_forever_outlined,
                  title: 'Borrar cuenta',
                  iconColor: Colors.red,
                  textColor: Colors.red,
                  onTap: () {
                    _showConfirmationDialog(
                      context: context,
                      title: 'Borrar cuenta',
                      content:
                          '¿Deseas borrar tu cuenta? Esta acción no puede deshacerse',
                      isDelete: true,
                      confirmText: 'Eliminar',
                      onConfirm: () async {
                        await userProvider.deleteUser(user.id!);

                        if (context.mounted) {
                          if (userProvider.errorMessage.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(userProvider.errorMessage),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Tu cuenta ha sido eliminada'),
                                backgroundColor: Color(0xFFFB8C00),
                              ),
                            );
                          }
                        }
                      },
                    );
                  },
                ),
                _buildMenuButton(
                  icon: Icons.logout,
                  title: 'Cerrar Sesión',
                  iconColor: Colors.red,
                  textColor: Colors.red,
                  onTap: () async {
                    _showConfirmationDialog(
                      context: context,
                      title: 'Cerrar Sesión',
                      content: '¿Deseas cerrar sesión?',
                      confirmText: 'Salir',
                      onConfirm: () async {
                        await userProvider.logout();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Sesión cerrada correctamente'),
                              backgroundColor: Color(0xFFFB8C00),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // menu buttons
  Widget _buildMenuButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFFFB8C00),
    Color textColor = Colors.black87,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
            color: textColor,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  void _showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmText,
    required VoidCallback onConfirm,
    bool isDelete = false,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          content: Text(
            content,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          actions: [
            // cancel
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            // confirm
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDelete
                    ? Colors.red
                    : const Color(0xFFFB8C00),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              child: Text(
                confirmText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
