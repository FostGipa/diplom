import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class TOutlinedButtonTheme {
  TOutlinedButtonTheme._();

  static final outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: TColors.green,
      side: const BorderSide(color: TColors.green),
      textStyle: const TextStyle(fontSize: 16, color: TColors.green, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(vertical: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))
    )
  );
}