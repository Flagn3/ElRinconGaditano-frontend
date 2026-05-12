import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rincongaditano/providers/user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _secondNameController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().activeUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _secondNameController = TextEditingController(text: user?.secondName ?? '');
    _addressController = TextEditingController(text: user?.address ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _secondNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.activeUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Editar Perfil',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        backgroundColor: const Color(0xFFFB8C00),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Modifica tus datos personales",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 30),

                // name
                _buildTextField(
                  label: "Nombre",
                  controller: _nameController,
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 20),

                // secondName
                _buildTextField(
                  label: "Apellidos",
                  controller: _secondNameController,
                  icon: Icons.badge_outlined,
                ),
                const SizedBox(height: 20),

                // address
                _buildTextField(
                  label: "Dirección",
                  controller: _addressController,
                  icon: Icons.location_on_outlined,
                ),

                const SizedBox(height: 40),

                // confirm button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: userProvider.isLoading
                        ? null
                        : () => _handleUpdate(userProvider, user?.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFB8C00),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: userProvider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Guardar Cambios",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Inter',
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontFamily: 'Inter'),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFFB8C00)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFFB8C00), width: 2),
        ),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? "Este campo es obligatorio" : null,
    );
  }

  Future<void> _handleUpdate(UserProvider provider, int? userId) async {
    if (!_formKey.currentState!.validate() || userId == null) return;

    await provider.updateUser(
      userId,
      _nameController.text.trim(),
      _secondNameController.text.trim(),
      _addressController.text.trim(),
    );

    if (mounted) {
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
            content: Text("Perfil actualizado correctamente"),
            backgroundColor: Color(0xFFFB8C00),
          ),
        );
        Navigator.pop(context);
      }
    }
  }
}
