import 'package:app/features/authentication/screens/signup/signup.dart';
import 'package:app/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/sizes.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.direct_right),
                      labelText: 'Email'),
                ),

                const SizedBox(
                    height: TSizes.spaceBtwInputFields),

                TextFormField(
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax
                          .password_check),
                      labelText: 'Пароль',
                      suffixIcon: Icon(Iconsax.eye_slash)
                  ),
                ),

                const SizedBox(
                    height: TSizes.spaceBtwInputFields / 2),

                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(value: true,
                            onChanged: (value) {}),
                        const Text('Запомнить меня'),
                      ],
                    ),

                    TextButton(
                        onPressed: () {}, child: const Text(
                        'Забыл пароль')),
                  ],
                ),

                const SizedBox(
                    height: TSizes.spaceBtwSections),

                SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Get.to(() => const NavigationMenu()), child: const Text('Войти'))),

                const SizedBox(
                    height: TSizes.spaceBtwItems),

                SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(onPressed: () => Get.to(() => const SignupScreen()), child: const Text('Регистрация'))
                ),
              ],
            )
        )
    );
  }
}