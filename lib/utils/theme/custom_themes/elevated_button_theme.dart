import 'package:app/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();

  static final elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: Colors.white,
      backgroundColor: TColors.green,
      disabledBackgroundColor: Colors.grey,
      disabledForegroundColor: Colors.grey,
      side: const BorderSide(color: TColors.green),
      padding: const EdgeInsets.symmetric(vertical: 18),
      textStyle: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
    )
  );
}