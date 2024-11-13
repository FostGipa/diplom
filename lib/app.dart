import 'package:app/features/authentication/screens/login/login.dart';
import 'package:app/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: TAppTheme.theme,
      home: const LoginScreen(),
    );
  }
}
