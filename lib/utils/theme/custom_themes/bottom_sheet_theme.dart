import 'package:flutter/material.dart';

class TBottomSheetTheme {
  TBottomSheetTheme._();
  
  static BottomSheetThemeData bottomSheetThemeData = BottomSheetThemeData(
    showDragHandle: true,
    backgroundColor: Colors.white,
    modalBackgroundColor: Colors.white,
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
  );
}