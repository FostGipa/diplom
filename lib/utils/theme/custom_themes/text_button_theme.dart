import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class TTextButtonTheme {
  TTextButtonTheme._();

  static final textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: TColors.green,
      textStyle: const TextStyle(color: TColors.green, fontSize: 16.0, fontWeight: FontWeight.w600),
    )
  );
}