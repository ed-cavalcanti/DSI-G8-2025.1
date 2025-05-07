import 'package:diainfo/constants/colors.dart';
import 'package:flutter/material.dart';

class AppTextFormFieldTheme {
  AppTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
    labelStyle: TextStyle(color: textPrimaryColor),
    prefixIconColor: blueStrokeColor,
    floatingLabelStyle: TextStyle(color: blueStrokeColor, fontSize: 16.0),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2.0, color: blueStrokeColor),
    ),
  );
}
