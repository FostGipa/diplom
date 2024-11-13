import 'package:app/features/authentication/screens/login/widgets/login_form.dart';
import 'package:app/features/authentication/screens/login/widgets/login_header.dart';
import 'package:flutter/material.dart';

import '../../../../common/styles/spacing_styles.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SingleChildScrollView(
            child: Padding(
                padding: TSpacingStyle.paddingWithAppBarHeight,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TLoginHeader(),

                      TLoginForm(),
                    ],
                ),
            ),
        )
    );
  }
}