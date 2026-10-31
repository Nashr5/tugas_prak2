import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'theme/pastel_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PastelGadgetApp());
}

class PastelGadgetApp extends StatelessWidget {
  const PastelGadgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pastel Phone Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
        scaffoldBackgroundColor: PastelColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: PastelColors.primary,
          primary: PastelColors.primary,
          secondary: PastelColors.secondary,
          surface: PastelColors.surface,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: PastelColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: PastelColors.textDark),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
