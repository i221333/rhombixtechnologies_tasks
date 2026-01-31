import 'package:flutter/material.dart';

/// Single modern theme configuration for the Art Gallery app.
/// Removed toggle logic and persistence as they are no longer needed.
class AppTheme {
  // Primary Seed Color: A modern Indigo/Slate hybrid
  static const Color _seedColor = Color(0xFF6366F1);
  static const Color _backgroundColor = Color(0xFF0F172A);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: _seedColor,
      scaffoldBackgroundColor: _backgroundColor,

      // App Bar: Seamless and modern
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: _backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      // Card: Subtle borders instead of heavy shadows
      cardTheme: CardThemeData(
        color: const Color(0xFF1E293B),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
        ),
      ),

      // Input: Deep fields with vibrant focus borders
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E293B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _seedColor, width: 2),
        ),
      ),

      // Buttons: Pill-shaped and impactful
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _seedColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _seedColor,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      // Chips: Modern pill style
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF1E293B),
        side: BorderSide(color: Colors.white.withOpacity(0.1)),
        shape: StadiumBorder(),
        labelStyle: const TextStyle(fontSize: 12),
      ),
    );
  }

  // ==================== UTILITIES (RETAINED) ====================

  static const artCategoryColors = {
    'Digital Painting': Color(0xFFC084FC),
    '3D Art': Color(0xFF60A5FA),
    'Photography': Color(0xFF34D399),
    'Illustration': Color(0xFFFB7185),
    'Abstract': Color(0xFFFBBF24),
    'Pixel Art': Color(0xFF2DD4BF),
    'Vector Art': Color(0xFFFB923C),
  };

  static Color getCategoryColor(String category) {
    return artCategoryColors[category] ?? const Color(0xFF94A3B8);
  }

  static const gradients = {
    'midnight': LinearGradient(
      colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    'ocean': LinearGradient(
      colors: [Color(0xFF0EA5E9), Color(0xFF2DD4BF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    'sunset': LinearGradient(
      colors: [Color(0xFFF43F5E), Color(0xFFFB923C)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  };
}