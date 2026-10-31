import 'package:flutter/material.dart';

class PastelColors {
  // Primary Pastel Violet / Lavender
  static const Color primary = Color(0xFF7E69AB);
  static const Color primaryLight = Color(0xFFF0ECF8);
  static const Color primarySoft = Color(0xFFD6CDE9);
  static const Color primaryDark = Color(0xFF5E498A);

  // Secondary Pastel Rose / Coral
  static const Color secondary = Color(0xFFFF9AA2);
  static const Color secondaryLight = Color(0xFFFFF0F2);
  static const Color secondarySoft = Color(0xFFFFD3D6);

  // Mint / Sage Pastel
  static const Color mint = Color(0xFF83C5BE);
  static const Color mintLight = Color(0xFFEBF7F5);
  static const Color mintDark = Color(0xFF006D77);

  // Peach / Buttercream
  static const Color peach = Color(0xFFFFB7A1);
  static const Color peachLight = Color(0xFFFFF4F0);

  // Sky / Baby Blue
  static const Color sky = Color(0xFF90C2E7);
  static const Color skyLight = Color(0xFFEEF6FC);

  // Butter Yellow
  static const Color butter = Color(0xFFFFDF9E);
  static const Color butterLight = Color(0xFFFFFBEB);

  // Neutral Backgrounds & Cards
  static const Color background = Color(0xFFF7F8FD);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF1F3F9);
  static const Color border = Color(0xFFE8EAF3);

  // Text colors
  static const Color textDark = Color(0xFF1E2433);
  static const Color textMedium = Color(0xFF5C6578);
  static const Color textLight = Color(0xFF9AA3B5);

  // Star Rating
  static const Color star = Color(0xFFFFB703);

  // Gradients for pastel accents
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF9780D3), Color(0xFF7E69AB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bannerGradient = LinearGradient(
    colors: [Color(0xFFD8D2F8), Color(0xFFF9D5E5), Color(0xFFFFE6D6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF9FAFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

