import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFC61A2B);
  static const Color primaryLight = Color(0xFFE24353);
  static const Color primaryDark = Color(0xFF8B0E1B);
  static const Color primarySurface = Color(0xFFFCE8EA);
  static const Color primaryBorder = Color(0xFFF0B3B8);
  static const Color accent = Color(0xFFE24353);

  // === GRADIENTS ===
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.55, 1.0],
    colors: [primaryLight, primary, primaryDark],
  );

  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color error = Colors.red;

  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFE0E0E0);

  // ── Dark Mode ────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF121212); // latar halaman
  static const Color darkSurface = Color(0xFF1E1E1E); // AppBar, bottom nav
  static const Color darkSurfaceCard = Color(0xFF2C2C2C); // kartu, input field

  static const Color darkTextPrimary = Color(0xFFEEEEEE);
  static const Color darkTextSecondary = Color(0xFFAAAAAA);
  static const Color darkTextHint = Color(0xFF666666);

  static const Color darkDivider = Color(0xFF3A3A3A);
  static const Color darkBorder = Color(0xFF3A3A3A);
}
