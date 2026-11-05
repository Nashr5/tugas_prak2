import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../theme/pastel_colors.dart';

/// Halaman Form untuk Tambah (Create) dan Edit (Update) Produk
/// Jika [product] null = mode Tambah, jika ada = mode Edit
class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  // Controllers untuk setiap field input
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _brandController;
  late TextEditingController _categoryController;
  late TextEditingController _discountController;
  late TextEditingController _thumbnailController;

  bool get _isEditMode => widget.product != null;

  @override
  void initState() {
    super.initState();
    // Jika mode Edit, isi controller dengan data produk yang ada
    _titleController = TextEditingController(text: widget.product?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.product?.description ?? '');
    _priceController =
        TextEditingController(text: widget.product?.price.toString() ?? '');
    _stockController =
        TextEditingController(text: widget.product?.stock.toString() ?? '');
    _brandController =
        TextEditingController(text: widget.product?.brand ?? '');
    _categoryController =
        TextEditingController(text: widget.product?.category ?? 'smartphones');
    _discountController = TextEditingController(
        text: widget.product?.discountPercentage.toString() ?? '0');
    _thumbnailController =
        TextEditingController(text: widget.product?.thumbnail ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _brandController.dispose();
    _categoryController.dispose();
    _discountController.dispose();
    _thumbnailController.dispose();
    super.dispose();
  }

  /// Menyimpan data produk (Create atau Update)
  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Buat objek Product dari data form
      final product = Product(
        id: widget.product?.id ?? 0,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _categoryController.text.trim(),
        price: double.tryParse(_priceController.text.trim()) ?? 0.0,
        discountPercentage:
            double.tryParse(_discountController.text.trim()) ?? 0.0,
        rating: widget.product?.rating ?? 0.0,
        stock: int.tryParse(_stockController.text.trim()) ?? 0,
        tags: widget.product?.tags ?? [],
        brand: _brandController.text.trim().isNotEmpty
            ? _brandController.text.trim()
            : null,
        reviews: widget.product?.reviews ?? [],
        images: widget.product?.images ?? [],
        thumbnail: _thumbnailController.text.trim(),
      );

      Product result;
      if (_isEditMode) {
        // UPDATE: Perbarui produk yang ada
        result = await _apiService.updateProduct(widget.product!.id, product);
      } else {
        // CREATE: Tambah produk baru
        result = await _apiService.createProduct(product);
      }

      if (!mounted) return;

      // Tampilkan notifikasi sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: PastelColors.mint,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _isEditMode
                      ? 'Produk "${result.title}" berhasil diperbarui!'
                      : 'Produk "${result.title}" berhasil ditambahkan!',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );

      // Kembali ke halaman sebelumnya dengan result = true (berhasil)
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: [
              const Icon(Icons.error_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Gagal menyimpan: $e',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PastelColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: PastelColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: PastelColors.border),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: PastelColors.textDark,
                      ),
                      onPressed: () => Navigator.pop(context),
                      tooltip: 'Kembali',
                    ),
                  ),
                  Text(
                    _isEditMode ? 'Edit Produk' : 'Tambah Produk Baru',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: PastelColors.textDark,
                    ),
                  ),
                  const SizedBox(width: 48), // Spacer agar judul di tengah
                ],
              ),
            ),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Info banner
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: PastelColors.primaryLight,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isEditMode
                                  ? Icons.edit_note_rounded
                                  : Icons.add_box_rounded,
                              color: PastelColors.primaryDark,
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _isEditMode
                                    ? 'Ubah data produk di bawah ini lalu tekan "Simpan Perubahan".'
                                    : 'Isi data produk baru di bawah ini lalu tekan "Tambah Produk".',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: PastelColors.primaryDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ---- INFORMASI UTAMA ----
                      _buildSectionTitle('Informasi Utama', Icons.info_outline_rounded),
                      const SizedBox(height: 12),

                      _buildTextField(
                        controller: _titleController,
                        label: 'Nama Produk',
                        hint: 'Contoh: iPhone 15 Pro Max',
                        icon: Icons.smartphone_rounded,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama produk wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      _buildTextField(
                        controller: _brandController,
                        label: 'Brand / Merek',
                        hint: 'Contoh: Apple, Samsung, Vivo',
                        icon: Icons.business_rounded,
                      ),
                      const SizedBox(height: 14),

                      _buildTextField(
                        controller: _categoryController,
                        label: 'Kategori',
                        hint: 'Contoh: smartphones',
                        icon: Icons.category_rounded,
                      ),
                      const SizedBox(height: 14),

                      _buildTextField(
                        controller: _descriptionController,
                        label: 'Deskripsi Produk',
                        hint: 'Tuliskan deskripsi lengkap produk...',
                        icon: Icons.description_outlined,
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Deskripsi produk wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // ---- HARGA & STOK ----
                      _buildSectionTitle('Harga & Stok', Icons.attach_money_rounded),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _priceController,
                              label: 'Harga (\$)',
                              hint: '999.99',
                              icon: Icons.monetization_on_outlined,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                              ],
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Harga wajib diisi';
                                }
                                final price = double.tryParse(value.trim());
                                if (price == null || price <= 0) {
                                  return 'Harga harus > 0';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              controller: _stockController,
                              label: 'Stok',
                              hint: '100',
                              icon: Icons.inventory_2_outlined,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Stok wajib diisi';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      _buildTextField(
                        controller: _discountController,
                        label: 'Diskon (%)',
                        hint: '0',
                        icon: Icons.discount_outlined,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // ---- GAMBAR ----
                      _buildSectionTitle('Gambar Produk', Icons.image_outlined),
                      const SizedBox(height: 12),

                      _buildTextField(
                        controller: _thumbnailController,
                        label: 'URL Gambar Thumbnail',
                        hint: 'https://contoh.com/gambar.png',
                        icon: Icons.link_rounded,
                      ),

                      // Preview gambar jika ada URL
                      if (_thumbnailController.text.trim().isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: PastelColors.surfaceMuted,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: PastelColors.border),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              _thumbnailController.text.trim(),
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.broken_image_rounded,
                                        size: 40,
                                        color: PastelColors.textLight),
                                    SizedBox(height: 8),
                                    Text(
                                      'Gambar tidak dapat dimuat',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: PastelColors.textLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 32),

                      // ---- TOMBOL SIMPAN ----
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PastelColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shadowColor:
                                PastelColors.primary.withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          onPressed: _isLoading ? null : _saveProduct,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation(
                                        Colors.white),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _isEditMode
                                          ? Icons.save_rounded
                                          : Icons.add_rounded,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _isEditMode
                                          ? 'Simpan Perubahan'
                                          : 'Tambah Produk',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget judul section dengan ikon
  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: PastelColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: PastelColors.textDark,
          ),
        ),
      ],
    );
  }

  /// Widget text field reusable dengan style pastel
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: PastelColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PastelColors.border),
        boxShadow: [
          BoxShadow(
            color: PastelColors.primary.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: PastelColors.textDark,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, size: 20, color: PastelColors.primary),
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: PastelColors.textMedium,
          ),
          hintStyle: const TextStyle(
            fontSize: 13,
            color: PastelColors.textLight,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          errorStyle: TextStyle(
            fontSize: 11,
            color: Colors.red.shade400,
          ),
        ),
      ),
    );
  }
}
