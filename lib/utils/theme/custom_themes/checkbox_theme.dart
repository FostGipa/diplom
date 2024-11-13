import 'package:app/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class TCheckboxTheme {
  TCheckboxTheme._();

  static CheckboxThemeData checkboxThemeData = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    checkColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.white;
      } else {
        return Colors.black;
      }
    }),
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return TColors.green;
      } else {
        return Colors.transparent;
      }
    }),
  );
}