import 'package:app/bindings/general_bindings.dart';
import 'package:app/features/authentication/screens/login/login.dart';
import 'package:app/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: TAppTheme.theme,
      home: const LoginScreen(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ru', 'RU'), // Добавляем русскую локализацию
        Locale('en', 'US'), // Английская локализация (по умолчанию)
      ],
      locale: Locale('ru', 'RU'),
      initialBinding: GeneralBindings(),
    );
  }
}
