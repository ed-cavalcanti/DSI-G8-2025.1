import 'package:diainfo/constants/colors.dart';
import 'package:diainfo/utils/theme/elevated_button_theme.dart';
import 'package:diainfo/utils/theme/text_field_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: TextTheme(
      titleSmall: GoogleFonts.inter(color: textPrimaryColor),
      titleMedium: GoogleFonts.inter(color: textPrimaryColor, fontSize: 24),
      titleLarge: GoogleFonts.inter(color: textPrimaryColor),
      bodySmall: GoogleFonts.inter(color: textPrimaryColor),
      bodyMedium: GoogleFonts.inter(color: textPrimaryColor),
      bodyLarge: GoogleFonts.inter(color: textPrimaryColor),
    ),
    inputDecorationTheme: AppTextFormFieldTheme.lightInputDecorationTheme,
    elevatedButtonTheme: AppElevatedButtonTheme.lightElevatedButtonTheme,
  );
}
