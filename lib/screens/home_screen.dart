import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../theme/pastel_colors.dart';
import '../widgets/banner_slider.dart';
import '../widgets/category_chips.dart';
import '../widgets/product_card.dart';
import '../widgets/search_bar_widget.dart';
import 'product_detail_screen.dart';
import 'product_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<Product> _allProducts = [];
  List<Product> _displayedProducts = [];
  bool _isLoading = true;
  String? _errorMessage;

  String _selectedCategory = 'Semua';
  String _activeSearchQuery = '';
  bool _isGridView = true;

  final List<String> _categories = [
    'Semua',
    'Apple',
    'Samsung',
    'Vivo',
    'Oppo',
    'Realme',
    'Diskon Spesial',
    'Top Rated ⭐',
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Mengambil data produk smartphone dari DummyJSON API
      final products = await _apiService.getSmartphones();
      setState(() {
        _allProducts = products;
        _isLoading = false;
        _applyFilters();
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // Fungsionalitas Tombol Search
  Future<void> _performSearch(String query) async {
    final trimmedQuery = query.trim();
    setState(() {
      _activeSearchQuery = trimmedQuery;
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (trimmedQuery.isEmpty) {
        // Jika query kosong, kembalikan ke list awal
        await _loadProducts();
        return;
      }

      // Memanggil API search DummyJSON
      final searchResults = await _apiService.searchProducts(trimmedQuery);

      setState(() {
        _allProducts = searchResults;
        _isLoading = false;
        _selectedCategory = 'Semua';
        _applyFilters();
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal mencari produk: $e';
        _isLoading = false;
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    _activeSearchQuery = '';
    _loadProducts();
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Product> filtered = List.from(_allProducts);

    // Filter berdasarkan kategori/brand
    if (_selectedCategory == 'Apple') {
      filtered = filtered
          .where((p) =>
              p.brandDisplay.toLowerCase().contains('apple') ||
              p.title.toLowerCase().contains('iphone'))
          .toList();
    } else if (_selectedCategory == 'Samsung') {
      filtered = filtered
          .where((p) =>
              p.brandDisplay.toLowerCase().contains('samsung') ||
              p.title.toLowerCase().contains('galaxy'))
          .toList();
    } else if (_selectedCategory == 'Vivo') {
      filtered = filtered
          .where((p) => p.brandDisplay.toLowerCase().contains('vivo'))
          .toList();
    } else if (_selectedCategory == 'Oppo') {
      filtered = filtered
          .where((p) => p.brandDisplay.toLowerCase().contains('oppo'))
          .toList();
    } else if (_selectedCategory == 'Realme') {
      filtered = filtered
          .where((p) => p.brandDisplay.toLowerCase().contains('realme'))
          .toList();
    } else if (_selectedCategory == 'Diskon Spesial') {
      filtered = filtered.where((p) => p.discountPercentage >= 10.0).toList();
      filtered.sort(
          (a, b) => b.discountPercentage.compareTo(a.discountPercentage));
    } else if (_selectedCategory == 'Top Rated ⭐') {
      filtered = filtered.where((p) => p.rating >= 4.0).toList();
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
    }

    _displayedProducts = filtered;
  }

  // ===== CRUD ACTIONS =====

  /// Navigasi ke halaman Tambah Produk Baru (CREATE)
  Future<void> _navigateToAddProduct() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const ProductFormScreen(),
      ),
    );

    // Jika berhasil menambah produk, reload data
    if (result == true) {
      _loadProducts();
    }
  }

  /// Navigasi ke halaman Edit Produk (UPDATE)
  Future<void> _navigateToEditProduct(Product product) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormScreen(product: product),
      ),
    );

    // Jika berhasil edit produk, reload data
    if (result == true) {
      _loadProducts();
    }
  }

  /// Menghapus produk dengan konfirmasi dialog (DELETE)
  Future<void> _deleteProduct(Product product) async {
    // Tampilkan dialog konfirmasi
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: PastelColors.surface,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: PastelColors.secondaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_forever_rounded,
                size: 48,
                color: PastelColors.secondary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Hapus Produk?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: PastelColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Apakah Anda yakin ingin menghapus "${product.title}"? Tindakan ini tidak dapat dibatalkan.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: PastelColors.textMedium,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: PastelColors.textDark,
                      side: const BorderSide(color: PastelColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Hapus'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (confirm != true) return;

    try {
      await _apiService.deleteProduct(product.id);
      if (!mounted) return;

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
                  'Produk "${product.title}" berhasil dihapus!',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );

      _loadProducts();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Text('Gagal menghapus: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PastelColors.background,

      // ===== FAB: Tombol Tambah Produk Baru =====
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddProduct,
        backgroundColor: PastelColors.primary,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        icon: const Icon(Icons.add_rounded, size: 22),
        label: const Text(
          'Tambah Produk',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        ),
      ),

      body: SafeArea(
        child: RefreshIndicator(
          color: PastelColors.primary,
          backgroundColor: PastelColors.surface,
          onRefresh: _loadProducts,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // Custom Header AppBar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Baris Atas: Profil & Notifikasi
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          PastelColors.primary.withValues(alpha: 0.25),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.asset(
                                    'assets/images/app_icon.png',
                                    width: 44,
                                    height: 44,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Nsh',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: PastelColors.primary,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      Text(
                                        'Store',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: PastelColors.secondary,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Text(
                                    'Pusat Belanja Smartphone Terbaik',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: PastelColors.textMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Tombol Keranjang Pastel
                          Container(
                            decoration: BoxDecoration(
                              color: PastelColors.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: PastelColors.border,
                                width: 1.2,
                              ),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.shopping_bag_outlined,
                                color: PastelColors.primaryDark,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: PastelColors.primary,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    content: const Text(
                                      'Keranjang belanja Anda kosong saat ini.',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              },
                              tooltip: 'Keranjang',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Widget Tombol Search Fungsional
                      SearchBarWidget(
                        controller: _searchController,
                        onSearch: _performSearch,
                        onClear: _clearSearch,
                      ),
                    ],
                  ),
                ),
              ),

              // Banner Promo Pastel (Hanya tampil jika bukan sedang dalam hasil pencarian)
              if (_activeSearchQuery.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 14),
                    child: PastelPromoBanner(),
                  ),
                ),

              // Filter Kategori Chips
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CategoryChips(
                    categories: _categories,
                    selectedCategory: _selectedCategory,
                    onSelected: _onCategorySelected,
                  ),
                ),
              ),

              // Status Pencarian Aktif jika ada
              if (_activeSearchQuery.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: PastelColors.primaryLight,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            size: 18,
                            color: PastelColors.primaryDark,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Hasil pencarian untuk: "$_activeSearchQuery"',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: PastelColors.primaryDark,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _clearSearch,
                            child: const Text(
                              'Reset',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: PastelColors.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Header Bagian Produk & Toggle Tampilan
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Katalog Handphone',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: PastelColors.textDark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: PastelColors.mintLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${_displayedProducts.length} Produk',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: PastelColors.mintDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.grid_view_rounded,
                              size: 20,
                              color: _isGridView
                                  ? PastelColors.primary
                                  : PastelColors.textLight,
                            ),
                            onPressed: () {
                              setState(() {
                                _isGridView = true;
                              });
                            },
                            tooltip: 'Tampilan Grid',
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.view_list_rounded,
                              size: 22,
                              color: !_isGridView
                                  ? PastelColors.primary
                                  : PastelColors.textLight,
                            ),
                            onPressed: () {
                              setState(() {
                                _isGridView = false;
                              });
                            },
                            tooltip: 'Tampilan List',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 8)),

              // Area Konten: Loading, Error, Empty, atau Grid Produk
              if (_isLoading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(PastelColors.primary),
                        ),
                        SizedBox(height: 14),
                        Text(
                          'Memuat produk NshStore...',
                          style: TextStyle(
                            fontSize: 13,
                            color: PastelColors.textMedium,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (_errorMessage != null)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: const BoxDecoration(
                              color: PastelColors.secondaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.cloud_off_rounded,
                              size: 48,
                              color: PastelColors.secondary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Gagal Mengambil Data',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: PastelColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              color: PastelColors.textMedium,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PastelColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: _loadProducts,
                            icon: const Icon(Icons.refresh_rounded, size: 18),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else if (_displayedProducts.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              color: PastelColors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.search_off_rounded,
                              size: 48,
                              color: PastelColors.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Smartphone Tidak Ditemukan',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: PastelColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Coba cari dengan kata kunci lain atau reset filter kategori.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: PastelColors.textMedium,
                            ),
                          ),
                          const SizedBox(height: 18),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: PastelColors.primary,
                              side: const BorderSide(
                                color: PastelColors.primary,
                                width: 1.4,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: _clearSearch,
                            icon: const Icon(Icons.restore_rounded, size: 18),
                            label: const Text('Tampilkan Semua'),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else if (_isGridView)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.63,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = _displayedProducts[index];
                        return ProductCard(
                          product: product,
                          onEdit: () => _navigateToEditProduct(product),
                          onDelete: () => _deleteProduct(product),
                          onProductUpdated: _loadProducts,
                        );
                      },
                      childCount: _displayedProducts.length,
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = _displayedProducts[index];
                        return _buildListItem(context, product);
                      },
                      childCount: _displayedProducts.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, Product product) {
    return Dismissible(
      key: ValueKey(product.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_rounded, color: Colors.white, size: 28),
            SizedBox(height: 4),
            Text(
              'Hapus',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        _deleteProduct(product);
        return false; // Kita handle sendiri di _deleteProduct
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(
                product: product,
                onProductUpdated: _loadProducts,
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: PastelColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: PastelColors.border),
            boxShadow: [
              BoxShadow(
                color: PastelColors.primary.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Thumbnail
              Container(
                width: 90,
                height: 90,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: PastelColors.primaryLight.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Image.network(
                  product.thumbnail,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.phone_android_rounded,
                    color: PastelColors.primarySoft,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: PastelColors.primaryLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            product.brandDisplay,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: PastelColors.primaryDark,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.star_rounded,
                          size: 15,
                          color: PastelColors.star,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: PastelColors.textDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: PastelColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Stok: ${product.stock} unit',
                      style: const TextStyle(
                        fontSize: 11,
                        color: PastelColors.textMedium,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          product.formattedPrice,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: PastelColors.primary,
                          ),
                        ),
                        if (product.discountPercentage > 0) ...[
                          const SizedBox(width: 6),
                          Text(
                            product.formattedOriginalPrice,
                            style: const TextStyle(
                              fontSize: 11,
                              decoration: TextDecoration.lineThrough,
                              color: PastelColors.textLight,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: PastelColors.secondary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '-${product.discountPercentage.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                        const Spacer(),
                        // Tombol Edit & Hapus di List View
                        InkWell(
                          onTap: () => _navigateToEditProduct(product),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: PastelColors.primaryLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.edit_rounded,
                              size: 16,
                              color: PastelColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: () => _deleteProduct(product),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: PastelColors.secondaryLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.delete_rounded,
                              size: 16,
                              color: Colors.red.shade400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
