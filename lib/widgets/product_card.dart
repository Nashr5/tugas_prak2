import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/pastel_colors.dart';
import '../screens/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onProductUpdated;

  const ProductCard({
    super.key,
    required this.product,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.onEdit,
    this.onDelete,
    this.onProductUpdated,
  });

  /// Menampilkan popup menu untuk Edit dan Hapus
  void _showActionMenu(BuildContext context, Offset tapPosition) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        tapPosition & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      color: PastelColors.surface,
      elevation: 8,
      items: [
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: PastelColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.edit_rounded,
                    size: 16, color: PastelColors.primary),
              ),
              const SizedBox(width: 10),
              const Text(
                'Edit Produk',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: PastelColors.textDark,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: PastelColors.secondaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.delete_rounded,
                    size: 16, color: Colors.red.shade400),
              ),
              const SizedBox(width: 10),
              Text(
                'Hapus Produk',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade400,
                ),
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'edit' && onEdit != null) {
        onEdit!();
      } else if (value == 'delete' && onDelete != null) {
        onDelete!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              product: product,
              onProductUpdated: onProductUpdated ?? onEdit,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: PastelColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: PastelColors.border.withValues(alpha: 0.8),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: PastelColors.primary.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Produk & Badges
            Expanded(
              flex: 11,
              child: Stack(
                children: [
                  // Background pastel untuk kontainer gambar
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          PastelColors.primaryLight.withValues(alpha: 0.5),
                          PastelColors.surfaceMuted,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Hero(
                      tag: 'product-${product.id}',
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Image.network(
                          product.thumbnail,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.phone_android_rounded,
                                size: 48,
                                color: PastelColors.primarySoft,
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: const AlwaysStoppedAnimation(
                                    PastelColors.primary,
                                  ),
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // Brand Chip Badge di Kiri Atas
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: PastelColors.surface.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 4,
                          ),
                        ],
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
                  ),

                  // Tombol Menu (Edit/Hapus) di Kanan Atas
                  if (onEdit != null || onDelete != null)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTapDown: (details) {
                          _showActionMenu(context, details.globalPosition);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: PastelColors.surface.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.more_vert_rounded,
                            size: 18,
                            color: PastelColors.textDark,
                          ),
                        ),
                      ),
                    ),

                  // Diskon Badge jika tanpa menu
                  if (product.discountPercentage > 0 &&
                      (onEdit == null && onDelete == null))
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: PastelColors.secondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '-${product.discountPercentage.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                  // Diskon Badge (posisi bawah-kanan jika ada menu)
                  if (product.discountPercentage > 0 &&
                      (onEdit != null || onDelete != null))
                    Positioned(
                      bottom: 8,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: PastelColors.secondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '-${product.discountPercentage.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Konten Detail Singkat Produk
            Expanded(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Rating & Stok
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: PastelColors.star,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: PastelColors.textDark,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: PastelColors.mintLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Stok ${product.stock}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: PastelColors.mintDark,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Judul Produk
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: PastelColors.textDark,
                        height: 1.25,
                      ),
                    ),

                    // Harga & Diskon
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (product.discountPercentage > 0)
                                Text(
                                  product.formattedOriginalPrice,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    decoration: TextDecoration.lineThrough,
                                    color: PastelColors.textLight,
                                  ),
                                ),
                              Text(
                                product.formattedPrice,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: PastelColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: PastelColors.primaryGradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: PastelColors.primary.withValues(alpha: 0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
