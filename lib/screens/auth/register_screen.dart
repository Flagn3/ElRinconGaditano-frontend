import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rincongaditano/providers/user_provider.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onNavigateToLogin;

  const RegisterScreen({super.key, required this.onNavigateToLogin});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _secondNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _secondNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      await userProvider.register(
        _nameController.text.trim(),
        _secondNameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
        _addressController.text.trim(),
      );

      if (mounted) {
        if (userProvider.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(userProvider.errorMessage),
              backgroundColor: Colors.redAccent,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Te has registrado con éxito!'),
              backgroundColor: Colors.green,
            ),
          );
          widget.onNavigateToLogin();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),

            const SizedBox(height: 24),

            // name
            TextFormField(
              controller: _nameController,
              enabled: !userProvider.isLoading,
              decoration: _buildInputDecoration('Nombre', Icons.person_outline),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Introduce tu nombre' : null,
            ),
            const SizedBox(height: 16),

            // secondName
            TextFormField(
              controller: _secondNameController,
              enabled: !userProvider.isLoading,
              decoration: _buildInputDecoration(
                'Apellidos',
                Icons.badge_outlined,
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Introduce tus apellidos'
                  : null,
            ),
            const SizedBox(height: 16),

            // email
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              enabled: !userProvider.isLoading,
              decoration: _buildInputDecoration('Email', Icons.email_outlined),
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Introduce tu correo';
                if (!value.contains('@')) return 'Introduce un correo válido';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // password
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              enabled: !userProvider.isLoading,
              decoration: _buildInputDecoration(
                'Contraseña',
                Icons.lock_outline,
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Introduce tu contraseña'
                  : null,
            ),
            const SizedBox(height: 16),

            // address
            TextFormField(
              controller: _addressController,
              enabled: !userProvider.isLoading,
              decoration: _buildInputDecoration(
                'Dirección',
                Icons.home_outlined,
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Introduce tu dirección'
                  : null,
            ),
            const SizedBox(height: 28),

            // button
            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: userProvider.isLoading ? null : _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFB8C00),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 2,
                ),
                child: userProvider.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'Registrarse',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '¿Ya tienes cuenta? ',
                  style: TextStyle(fontFamily: 'Inter'),
                ),
                GestureDetector(
                  onTap: userProvider.isLoading
                      ? null
                      : widget.onNavigateToLogin,
                  child: const Text(
                    'Inicia sesión',
                    style: TextStyle(
                      color: Color(0xFFFB8C00),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFFB8C00), width: 2),
      ),
    );
  }
}
