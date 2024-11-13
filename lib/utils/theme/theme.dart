import 'package:app/utils/theme/custom_themes/appbar_theme.dart';
import 'package:app/utils/theme/custom_themes/checkbox_theme.dart';
import 'package:app/utils/theme/custom_themes/chip_theme.dart';
import 'package:app/utils/theme/custom_themes/custom_theme.dart';
import 'package:app/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:app/utils/theme/custom_themes/outlined_button_theme.dart';
import 'package:app/utils/theme/custom_themes/text_button_theme.dart';
import 'package:app/utils/theme/custom_themes/text_field_theme.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class TAppTheme {

  TAppTheme._();

  static ThemeData theme = ThemeData(
    useMaterial3: true,
    fontFamily: 'VK Sans',
    brightness: Brightness.light,
    primaryColor: TColors.green,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TTextTheme.textTheme,
    elevatedButtonTheme: TElevatedButtonTheme.elevatedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.inputDecorationTheme,
    checkboxTheme: TCheckboxTheme.checkboxThemeData,
    appBarTheme: TAppBarTheme.appBarTheme,
    chipTheme: TChipTheme.chipTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.outlinedButtonTheme,
    textButtonTheme: TTextButtonTheme.textButtonTheme,
  );
}