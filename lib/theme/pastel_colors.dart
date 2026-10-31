import 'package:flutter/material.dart';

/// Palet warna aplikasi bertema Sea Color Combinations (Kombinasi Warna Laut & Samudra)
/// Dilengkapi dengan warna laut dalam (Deep Ocean Teal & Navy), seafoam aqua, sky breeze,
/// serta aksen keemasan pantai (Golden Sand).
class PastelColors {
  // Primary Sea Colors: Deep Ocean Teal & Navy
  static const Color primary = Color(0xFF166A86); // Deep Ocean Teal
  static const Color primaryLight = Color(0xFFE2F6F7); // Soft Seafoam Mist
  static const Color primarySoft = Color(0xFF9EE1DB); // Gentle Sea Aqua
  static const Color primaryDark = Color(0xFF053549); // Deepest Abyssal Navy

  // Secondary Sea Colors: Vibrant Wave Blue
  static const Color secondary = Color(0xFF2E88BC); // Vibrant Sea Blue
  static const Color secondaryLight = Color(0xFFE8F4FA); // Soft Wave Tint
  static const Color secondarySoft = Color(0xFFBCE0F2); // Calming Sky Aqua

  // Seafoam & Turquoise Mint
  static const Color mint = Color(0xFF63CBC4); // Aqua Marine
  static const Color mintLight = Color(0xFFD6FFF7); // Seafoam Ice
  static const Color mintDark = Color(0xFF0A4E52); // Deep Pine Sea

  // Beach Sand / Shell
  static const Color peach = Color(0xFFE4C3A2); // Sandy Beige
  static const Color peachLight = Color(0xFFFAF3EC); // Soft Shell Mist

  // Clear Sky & Ocean Horizon
  static const Color sky = Color(0xFF8FC8E3); // Sea Breeze Sky
  static const Color skyLight = Color(0xFFEFF7FC); // Gentle Sky Tint

  // Golden Sun / Coastal Sunlight
  static const Color butter = Color(0xFFFEC23E); // Sea Sun Amber
  static const Color butterLight = Color(0xFFFFF8E7); // Warm Sunlight Tint

  // Neutral Backgrounds & Surfaces (Coastal Clean)
  static const Color background = Color(0xFFF4F9FA); // Fresh Coastal Breeze
  static const Color surface = Color(0xFFFFFFFF); // Pure White Surface
  static const Color surfaceMuted = Color(0xFFEBF3F5); // Muted Sea Foam Gray
  static const Color border = Color(0xFFDCEBED); // Subtle Ocean Border

  // Typography (Deep Oceanic Contrast)
  static const Color textDark = Color(0xFF053549); // Deep Navy Text (Ultra sharp & readable)
  static const Color textMedium = Color(0xFF486976); // Ocean Slate Gray
  static const Color textLight = Color(0xFF8CA5B1); // Soft Marine Gray

  // Star Rating & Badges
  static const Color star = Color(0xFFFEC23E); // Golden Sea Sun

  // Gradients bertema Sea Color Combinations
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF38B0B4), Color(0xFF166A86)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bannerGradient = LinearGradient(
    colors: [
      Color(0xFFD6FFF7), // Sea Foam
      Color(0xFFC4EBF2), // Clear Lagoon
      Color(0xFFDBEFF8), // Ocean Sky
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF6FBFC)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

// Alias SeaColors untuk penamaan yang lebih representatif
typedef SeaColors = PastelColors;
typedef AppColors = PastelColors;

