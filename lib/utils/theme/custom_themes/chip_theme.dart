import 'package:app/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class TChipTheme {
  TChipTheme._();

  static ChipThemeData chipTheme = ChipThemeData(
    disabledColor: Colors.grey.withOpacity(0.4),
    labelStyle: const TextStyle(color: Colors.black),
    selectedColor: TColors.green,
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: Colors.white
  );
}