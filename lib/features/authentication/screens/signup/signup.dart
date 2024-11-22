import 'package:app/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {

  int value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Создать аккаунт", style: Theme.of(context).textTheme.headlineMedium),

              const SizedBox(height: TSizes.spaceBtwSections),

              const TSignupForm(),
            ],
          ),
        ),
      ),
    );
  }
}