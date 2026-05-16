import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rincongaditano/models/product.dart';
import 'package:rincongaditano/providers/category_provider.dart';
import 'package:rincongaditano/providers/product_provider.dart';
import 'package:rincongaditano/services/cloudinary_service.dart';

class ProductForm extends StatefulWidget {
  final Product? product;

  const ProductForm({super.key, this.product});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();

  bool _available = true;
  int? _selectedCategoryId;
  File? _selectedImage;
  String? _currentImageUrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().getAllCategories();
    });

    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _descController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
      _available = widget.product!.available;
      _currentImageUrl = widget.product!.image;

      final categories = context.read<CategoryProvider>().categories;
      final matchedCategory = categories.firstWhere(
        (cat) =>
            cat.name.toLowerCase() ==
            widget.product!.categoryName.toLowerCase(),
        orElse: () => categories.first,
      );
      _selectedCategoryId = matchedCategory.id;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  void _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, asocia una categoría'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    final provider = context.read<ProductProvider>();
    String finalImageUrl = _currentImageUrl ?? '';

    if (_selectedImage != null) {
      String? uploadedUrl = await CloudinaryService.uploadImage(
        _selectedImage!,
      );
      if (uploadedUrl != null) {
        finalImageUrl = uploadedUrl;
      } else {
        setState(() => _isSaving = false);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al subir la imagen del producto'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    final double priceValue =
        double.tryParse(_priceController.text.trim()) ?? 0.0;

    if (widget.product == null) {
      await provider.createProduct(
        _nameController.text.trim(),
        _descController.text.trim(),
        priceValue,
        _available,
        _selectedCategoryId!,
        finalImageUrl,
      );
    } else {
      await provider.updateproduct(
        widget.product!.id!,
        _nameController.text.trim(),
        _descController.text.trim(),
        priceValue,
        _available,
        _selectedCategoryId!,
      );
    }

    setState(() => _isSaving = false);

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
        SnackBar(
          content: Text(
            widget.product == null
                ? 'Producto creado con éxito'
                : 'Producto actualizado',
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final categoryProvider = context.watch<CategoryProvider>();
    final isEditing = widget.product != null;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isEditing ? 'Editar Producto' : 'Nuevo Producto',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // image
                GestureDetector(
                  onTap: _isSaving ? null : _pickImage,
                  child: Container(
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(11),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : _currentImageUrl != null &&
                              _currentImageUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(11),
                            child: Image.network(
                              _currentImageUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo_outlined,
                                size: 30,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Imagen del Producto',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _nameController,
                  enabled: !_isSaving,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Nombre del Producto',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'El nombre es obligatorio'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descController,
                  enabled: !_isSaving,
                  maxLines: 2,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _priceController,
                  enabled: !_isSaving,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Precio',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: const Icon(Icons.euro),
                  ),
                  validator: (v) => v == null || double.tryParse(v) == null
                      ? 'Introduce un precio válido'
                      : null,
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<int>(
                  initialValue: _selectedCategoryId,
                  hint: const Text('Seleccionar Categoría'),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.category_outlined),
                  ),
                  items: categoryProvider.categories.map((cat) {
                    return DropdownMenuItem<int>(
                      value: cat.id,
                      child: Text(cat.name),
                    );
                  }).toList(),
                  onChanged: _isSaving
                      ? null
                      : (value) => setState(() => _selectedCategoryId = value),
                  validator: (v) => v == null ? 'Asigna una categoría' : null,
                ),
                const SizedBox(height: 12),

                SwitchListTile(
                  title: const Text('¿Producto disponible de inmediato?'),
                  value: _available,
                  activeThumbColor: Colors.orange,
                  contentPadding: EdgeInsets.zero,
                  onChanged: _isSaving
                      ? null
                      : (v) => setState(() => _available = v),
                ),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: _isSaving ? null : _saveForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          isEditing ? 'Guardar Cambios' : 'Crear Producto',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
}
