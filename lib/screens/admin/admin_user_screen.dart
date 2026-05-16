import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rincongaditano/models/user.dart';
import 'package:rincongaditano/providers/user_provider.dart';

class AdminUserScreen extends StatefulWidget {
  const AdminUserScreen({super.key});

  @override
  State<AdminUserScreen> createState() => _AdminUserScreenState();
}

class _AdminUserScreenState extends State<AdminUserScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().getAllUsers();
    });
  }

  Future<void> _handleRefresh() async {
    await context.read<UserProvider>().getAllUsers();
  }

  void _confirmDeleteUser(User user) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Eliminar Usuario',
          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
        ),
        content: Text(
          '¿Seguro que quieres eliminar a ${user.name ?? 'este usuario'}?',
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

    if (confirm == true && user.id != null) {
      if (!mounted) return;
      final provider = context.read<UserProvider>();
      await provider.deleteUser(user.id!);

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
            content: Text(
              'Usuario eliminado con éxito',
              style: TextStyle(fontFamily: 'Inter'),
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final clientUsers = userProvider.userList
        .where((user) => user.role != 'ROLE_ADMIN' && !user.deleted!)
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Gestión de Usuarios',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFB8C00),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: userProvider.isLoading && clientUsers.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : clientUsers.isEmpty
          ? RefreshIndicator(
              onRefresh: _handleRefresh,
              color: Colors.orange,
              child: ListView(
                children: const [
                  SizedBox(height: 100),
                  Center(
                    child: Text(
                      'No hay clientes registrados.',
                      style: TextStyle(fontFamily: 'Inter'),
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _handleRefresh,
              color: Colors.orange,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: clientUsers.length,
                itemBuilder: (context, index) {
                  final user = clientUsers[index];
                  final isActivated = user.activated ?? true;

                  return Dismissible(
                    key: Key(user.id.toString()),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (_) async {
                      _confirmDeleteUser(user);
                      return false;
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade600,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    child: Opacity(
                      opacity: isActivated ? 1.0 : 0.55,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          leading: CircleAvatar(
                            radius: 23,
                            backgroundColor: const Color(
                              0xFFFB8C00,
                            ).withOpacity(0.12),
                            child: const Icon(
                              Icons.person,
                              color: Color(0xFFFB8C00),
                              size: 26,
                            ),
                          ),
                          title: Text(
                            '${user.name ?? 'Sin nombre'} ${user.secondName ?? ''}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'Inter',
                            ),
                          ),
                          subtitle: Text(
                            user.email ?? '',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                              fontFamily: 'Inter',
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 30,
                                width: 50,
                                child: Transform.scale(
                                  scale: 0.8,
                                  child: Switch(
                                    value: isActivated,
                                    activeThumbColor: Colors.green,
                                    onChanged: (value) async {
                                      if (user.id != null) {
                                        await context
                                            .read<UserProvider>()
                                            .editActivation(
                                              user.id!,
                                              isActivated,
                                            );
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Text(
                                isActivated ? 'Activo' : 'Desactivado',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: isActivated
                                      ? Colors.green
                                      : Colors.grey[600],
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
