import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/pastel_colors.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  // Variasi warna pastel smartphone
  final List<Map<String, dynamic>> _pastelColorVariants = [
    {'name': 'Pastel Lilac', 'color': const Color(0xFFCDB4DB)},
    {'name': 'Blush Pink', 'color': const Color(0xFFFFC8DD)},
    {'name': 'Mint Sage', 'color': const Color(0xFFB9FBC0)},
    {'name': 'Pastel Sky', 'color': const Color(0xFFA0C4FF)},
    {'name': 'Phantom Dark', 'color': const Color(0xFF3D405B)},
  ];
  int _selectedColorIndex = 0;

  // Variasi memori internal
  final List<String> _storageVariants = ['128 GB', '256 GB', '512 GB', '1 TB'];
  int _selectedStorageIndex = 1;

  bool _isFavorite = false;
  int _quantity = 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showCheckoutBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final totalPrice = widget.product.price * _quantity;
            final selectedColor =
                _pastelColorVariants[_selectedColorIndex]['name'];
            final selectedStorage = _storageVariants[_selectedStorageIndex];

            return Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: const BoxDecoration(
                color: PastelColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: PastelColors.border,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Konfirmasi Pesanan Handphone',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: PastelColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: PastelColors.primaryLight,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Image.network(
                          widget.product.thumbnail,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: PastelColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$selectedColor • $selectedStorage',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: PastelColors.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.product.formattedPrice,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: PastelColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 28),
                  // Kuantitas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Jumlah Pembelian',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: PastelColors.textDark,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _quantity > 1
                                ? () {
                                    setModalState(() {
                                      _quantity--;
                                    });
                                    setState(() {});
                                  }
                                : null,
                            icon: const Icon(Icons.remove_circle_outline),
                            color: PastelColors.primary,
                          ),
                          Text(
                            '$_quantity',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: PastelColors.textDark,
                            ),
                          ),
                          IconButton(
                            onPressed: _quantity < widget.product.stock
                                ? () {
                                    setModalState(() {
                                      _quantity++;
                                    });
                                    setState(() {});
                                  }
                                : null,
                            icon: const Icon(Icons.add_circle_outline),
                            color: PastelColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Total Harga
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: PastelColors.primaryLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Pembayaran:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: PastelColors.primaryDark,
                          ),
                        ),
                        Text(
                          '\$${totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: PastelColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PastelColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _showSuccessDialog();
                      },
                      child: const Text(
                        'Bayar Sekarang',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
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
                color: PastelColors.mintLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                size: 52,
                color: PastelColors.mintDark,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pesanan Berhasil!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: PastelColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Terima kasih telah memesan ${widget.product.title}. Kami akan segera memproses pengiriman smartphone Anda.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: PastelColors.textMedium,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: PastelColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 12,
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Selesai'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.product.images.isNotEmpty
        ? widget.product.images
        : [widget.product.thumbnail];

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
                  const Text(
                    'Detail Handphone',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: PastelColors.textDark,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: PastelColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: PastelColors.border),
                        ),
                        child: IconButton(
                          icon: Icon(
                            _isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: _isFavorite
                                ? PastelColors.secondary
                                : PastelColors.textDark,
                          ),
                          onPressed: () {
                            setState(() {
                              _isFavorite = !_isFavorite;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: _isFavorite
                                    ? PastelColors.secondary
                                    : PastelColors.textDark,
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                content: Text(
                                  _isFavorite
                                      ? 'Ditambahkan ke daftar favorit 💕'
                                      : 'Dihapus dari daftar favorit',
                                ),
                              ),
                            );
                          },
                          tooltip: 'Favorit',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: PastelColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: PastelColors.border),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.share_outlined,
                            size: 20,
                            color: PastelColors.textDark,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: PastelColors.primary,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                content: Text(
                                  'Tautan produk ${widget.product.title} disalin! 🔗',
                                ),
                              ),
                            );
                          },
                          tooltip: 'Bagikan',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Konten Scrollable
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Area Carousel Gambar dengan Tema Pastel
                    Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: PastelColors.surface,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: PastelColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: PastelColors.primary.withValues(alpha: 0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 250,
                            child: Hero(
                              tag: 'product-${widget.product.id}',
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: images.length,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentImageIndex = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Image.network(
                                      images[index],
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Center(
                                        child: Icon(
                                          Icons.phone_android_rounded,
                                          size: 80,
                                          color: PastelColors.primarySoft,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          // Indikator Titik Carousel
                          if (images.length > 1)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  images.length,
                                  (index) => AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    width: _currentImageIndex == index ? 22 : 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: _currentImageIndex == index
                                          ? PastelColors.primary
                                          : PastelColors.primarySoft
                                              .withValues(alpha: 0.6),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          // Thumbnail List jika lebih dari 1 gambar
                          if (images.length > 1)
                            Container(
                              height: 60,
                              margin: const EdgeInsets.only(bottom: 14),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: images.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 10),
                                itemBuilder: (context, index) {
                                  final isCurrent =
                                      _currentImageIndex == index;
                                  return GestureDetector(
                                    onTap: () {
                                      _pageController.animateToPage(
                                        index,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      width: 52,
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: PastelColors.surfaceMuted,
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isCurrent
                                              ? PastelColors.primary
                                              : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                      child: Image.network(
                                        images[index],
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Card Informasi Utama Smartphone
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: PastelColors.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: PastelColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Badges (Brand, Kategori, Status Ketersediaan)
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: PastelColors.primaryLight,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    widget.product.brandDisplay,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: PastelColors.primaryDark,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: PastelColors.mintLight,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        size: 13,
                                        color: PastelColors.mintDark,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Stok Tersedia (${widget.product.stock})',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: PastelColors.mintDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Judul Smartphone
                            Text(
                              widget.product.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: PastelColors.textDark,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Rating & Jumlah Ulasan
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  size: 20,
                                  color: PastelColors.star,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.product.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: PastelColors.textDark,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '• (${widget.product.reviews.length} Ulasan Pembeli)',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: PastelColors.textMedium,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                if (widget.product.sku != null)
                                  Text(
                                    'SKU: ${widget.product.sku}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: PastelColors.textLight,
                                    ),
                                  ),
                              ],
                            ),
                            const Divider(height: 28),

                            // Harga & Diskon Pastel
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  widget.product.formattedPrice,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    color: PastelColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                if (widget.product.discountPercentage > 0) ...[
                                  Text(
                                    widget.product.formattedOriginalPrice,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      decoration: TextDecoration.lineThrough,
                                      color: PastelColors.textLight,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: PastelColors.secondary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      widget.product.formattedDiscount,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            if (widget.product.discountPercentage > 0)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  'Hemat \$${widget.product.savedAmount.toStringAsFixed(2)} dari harga ritel resmi!',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: PastelColors.mintDark,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Pemilihan Varian Warna Pastel
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: PastelColors.surface,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: PastelColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Pilihan Warna Pastel',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: PastelColors.textDark,
                                  ),
                                ),
                                Text(
                                  _pastelColorVariants[_selectedColorIndex]
                                      ['name'] as String,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: PastelColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: List.generate(
                                _pastelColorVariants.length,
                                (index) {
                                  final item = _pastelColorVariants[index];
                                  final isSelected =
                                      _selectedColorIndex == index;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedColorIndex = index;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      margin: const EdgeInsets.only(right: 12),
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: item['color'] as Color,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? PastelColors.primaryDark
                                              : Colors.white,
                                          width: isSelected ? 3 : 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.12),
                                            blurRadius: 6,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: isSelected
                                          ? const Icon(
                                              Icons.check,
                                              size: 20,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Pemilihan Kapasitas Penyimpanan (Storage)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: PastelColors.surface,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: PastelColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Kapasitas Memori (ROM)',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: PastelColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: List.generate(
                                _storageVariants.length,
                                (index) {
                                  final storage = _storageVariants[index];
                                  final isSelected =
                                      _selectedStorageIndex == index;
                                  return Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedStorageIndex = index;
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          right: index <
                                                  _storageVariants.length - 1
                                              ? 8
                                              : 0,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? PastelColors.primary
                                              : PastelColors.surfaceMuted,
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          border: Border.all(
                                            color: isSelected
                                                ? PastelColors.primary
                                                : PastelColors.border,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            storage,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: isSelected
                                                  ? FontWeight.w700
                                                  : FontWeight.w600,
                                              color: isSelected
                                                  ? Colors.white
                                                  : PastelColors.textDark,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Spesifikasi Lengkap Produk
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: PastelColors.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: PastelColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.tune_rounded,
                                  size: 18,
                                  color: PastelColors.primary,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Spesifikasi Smartphone',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: PastelColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _buildSpecRow('Brand Resmi', widget.product.brandDisplay),
                            _buildSpecRow(
                              'Garansi',
                              widget.product.warrantyInformation ??
                                  'Garansi Resmi 1 Tahun',
                            ),
                            _buildSpecRow(
                              'Pengiriman',
                              widget.product.shippingInformation ??
                                  'Tersedia Pengiriman Cepat',
                            ),
                            _buildSpecRow(
                              'Kebijakan Retur',
                              widget.product.returnPolicy ??
                                  '30 Hari Pengembalian Gratis',
                            ),
                            if (widget.product.dimensions != null)
                              _buildSpecRow(
                                'Dimensi Produk',
                                widget.product.dimensions!.formatted,
                              ),
                            if (widget.product.weight != null)
                              _buildSpecRow(
                                'Bobot Produk',
                                '${widget.product.weight} gram',
                              ),
                            _buildSpecRow(
                              'Minimal Pembelian',
                              '${widget.product.minimumOrderQuantity ?? 1} unit',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Deskripsi Produk
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: PastelColors.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: PastelColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.description_outlined,
                                  size: 18,
                                  color: PastelColors.primary,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Deskripsi Produk',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: PastelColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              widget.product.description,
                              style: const TextStyle(
                                fontSize: 13,
                                color: PastelColors.textMedium,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Ulasan Pembeli (Customer Reviews)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: PastelColors.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: PastelColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.rate_review_outlined,
                                      size: 18,
                                      color: PastelColors.primary,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Ulasan Pelanggan',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: PastelColors.textDark,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: PastelColors.butterLight,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.star_rounded,
                                        size: 15,
                                        color: PastelColors.star,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        widget.product.rating.toStringAsFixed(1),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: PastelColors.textDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            if (widget.product.reviews.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  'Belum ada ulasan untuk produk ini.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: PastelColors.textLight,
                                  ),
                                ),
                              )
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: widget.product.reviews.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(height: 20),
                                itemBuilder: (context, index) {
                                  final review = widget.product.reviews[index];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 14,
                                            backgroundColor:
                                                PastelColors.primaryLight,
                                            child: Text(
                                              review.reviewerName.isNotEmpty
                                                  ? review.reviewerName[0]
                                                  : 'U',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                color: PastelColors.primaryDark,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  review.reviewerName,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    color:
                                                        PastelColors.textDark,
                                                  ),
                                                ),
                                                if (review.date.isNotEmpty)
                                                  Text(
                                                    review.date.length > 10
                                                        ? review.date
                                                            .substring(0, 10)
                                                        : review.date,
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      color:
                                                          PastelColors.textLight,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: List.generate(
                                              5,
                                              (starIndex) => Icon(
                                                starIndex < review.rating
                                                    ? Icons.star_rounded
                                                    : Icons.star_border_rounded,
                                                size: 14,
                                                color: PastelColors.star,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '"${review.comment}"',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                          color: PastelColors.textMedium,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Action Bar (Chat, Keranjang, Beli Sekarang)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: PastelColors.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(26),
                  topRight: Radius.circular(26),
                ),
                boxShadow: [
                  BoxShadow(
                    color: PastelColors.primary.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Tombol Chat
                  Container(
                    decoration: BoxDecoration(
                      color: PastelColors.primaryLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.chat_bubble_outline_rounded,
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
                              'Menghubungkan ke layanan customer service...',
                            ),
                          ),
                        );
                      },
                      tooltip: 'Chat Penjual',
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Tombol Keranjang
                  Container(
                    decoration: BoxDecoration(
                      color: PastelColors.secondaryLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.add_shopping_cart_rounded,
                        color: PastelColors.secondary,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: PastelColors.secondary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            content: Text(
                              '${widget.product.title} ditambahkan ke keranjang!',
                            ),
                          ),
                        );
                      },
                      tooltip: 'Tambah ke Keranjang',
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Tombol Beli Sekarang (Pastel Gradient)
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PastelColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        onPressed: _showCheckoutBottomSheet,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_bag_rounded, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Beli Sekarang',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: PastelColors.textMedium,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: PastelColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
