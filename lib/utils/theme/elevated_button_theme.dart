import 'package:diainfo/constants/colors.dart';
import 'package:flutter/material.dart';

class AppElevatedButtonTheme {
  AppElevatedButtonTheme._();

  static ElevatedButtonThemeData lightElevatedButtonTheme =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor, // Cor de fundo padrão do botão
          foregroundColor: secondaryColor, // Cor do texto/ícone do botão
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ), // Estilo do texto
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ), // Padding do botão
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Bordas arredondadas
          ),
        ),
      );
}
