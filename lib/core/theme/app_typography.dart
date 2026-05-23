import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static TextTheme get textTheme {
    // Body font: Outfit
    final bodyFont = GoogleFonts.outfitTextTheme();
    
    // Heading font: Playfair Display
    final displayLarge = GoogleFonts.playfairDisplay(fontSize: 57, fontWeight: FontWeight.bold);
    final displayMedium = GoogleFonts.playfairDisplay(fontSize: 45, fontWeight: FontWeight.bold);
    final displaySmall = GoogleFonts.playfairDisplay(fontSize: 36, fontWeight: FontWeight.bold);
    final headlineLarge = GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.bold);
    final headlineMedium = GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.w600);
    final headlineSmall = GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.w600);
    
    // Subtitles also use Playfair for a touch of elegance
    final titleLarge = GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.w600);
    
    // Everything else uses Outfit
    return bodyFont.copyWith(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      // Outfit overrides for body
      titleMedium: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
      titleSmall: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500),
      bodyLarge: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.normal),
      bodyMedium: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.normal),
      bodySmall: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.normal),
      labelLarge: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1.2),
      labelMedium: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 1.2),
      labelSmall: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 1.2),
    );
  }
}
