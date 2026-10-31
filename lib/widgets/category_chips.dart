import 'package:flutter/material.dart';
import '../theme/pastel_colors.dart';

class CategoryChips extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  const CategoryChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Semua':
        return Icons.grid_view_rounded;
      case 'Apple':
        return Icons.apple;
      case 'Samsung':
        return Icons.phone_android_rounded;
      case 'Vivo':
        return Icons.devices_other_rounded;
      case 'Oppo':
        return Icons.mobile_screen_share_rounded;
      case 'Realme':
        return Icons.ad_units_rounded;
      case 'Diskon Spesial':
        return Icons.local_offer_rounded;
      case 'Top Rated ⭐':
        return Icons.star_rounded;
      default:
        return Icons.smartphone_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = cat == selectedCategory;

          return GestureDetector(
            onTap: () => onSelected(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? PastelColors.primary
                    : PastelColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? PastelColors.primary
                      : PastelColors.border,
                  width: 1.2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: PastelColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getIconForCategory(cat),
                    size: 16,
                    color: isSelected ? Colors.white : PastelColors.textMedium,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cat,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w600,
                      color:
                          isSelected ? Colors.white : PastelColors.textMedium,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
