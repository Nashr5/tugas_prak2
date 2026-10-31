import 'package:flutter/material.dart';
import '../theme/pastel_colors.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearch;
  final VoidCallback onClear;
  final ValueChanged<String>? onChanged;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.onClear,
    this.onChanged,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _hasText = widget.controller.text.isNotEmpty;
    widget.controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    final hasNow = widget.controller.text.isNotEmpty;
    if (_hasText != hasNow) {
      setState(() {
        _hasText = hasNow;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: PastelColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: PastelColors.primarySoft.withValues(alpha: 0.5),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: PastelColors.primary.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Row(
        children: [
          const SizedBox(width: 10),
          const Icon(
            Icons.search_rounded,
            color: PastelColors.primary,
            size: 22,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: widget.controller,
              onChanged: widget.onChanged,
              onSubmitted: (value) {
                widget.onSearch(value);
              },
              textInputAction: TextInputAction.search,
              style: const TextStyle(
                fontSize: 14,
                color: PastelColors.textDark,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                hintText: 'Cari iPhone, Samsung, Vivo...',
                hintStyle: TextStyle(
                  color: PastelColors.textLight,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          if (_hasText)
            IconButton(
              icon: const Icon(
                Icons.cancel_rounded,
                size: 20,
                color: PastelColors.textLight,
              ),
              onPressed: () {
                widget.controller.clear();
                widget.onClear();
              },
              splashRadius: 18,
              tooltip: 'Hapus Pencarian',
            ),
          // Tombol Search Pastel yang fungsional
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();
                widget.onSearch(widget.controller.text);
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: PastelColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: PastelColors.primary.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.search_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Cari',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
