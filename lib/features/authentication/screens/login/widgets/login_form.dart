import 'package:app/features/authentication/controllers/login/login_controller.dart';
import 'package:app/features/authentication/screens/signup/signup.dart';
import 'package:app/utils/validators/validation.dart';
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
    final controller = Get.put(LoginController());

    return Form(
        key: controller.loginFormKey,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Column(
              children: [
                TextFormField(
                  controller: controller.email,
                  validator: (value) => TValidator.validateEmail(value),
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.direct_right),
                      labelText: 'Email'),
                ),

                const SizedBox(
                    height: TSizes.spaceBtwInputFields),

                Obx(
                  () => TextFormField(
                    controller: controller.password,
                    obscureText: controller.hidePassword.value,
                    validator: (value) => TValidator.validatePassword(value),
                    decoration: InputDecoration(
                      labelText: "Пароль",
                      prefixIcon: Icon(Iconsax.password_check),
                      suffixIcon: IconButton(
                        onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                        icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
                      )
                    ),
                  )
                ),

                const SizedBox(
                    height: TSizes.spaceBtwInputFields / 2),

                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween,
                  children: [
                    Row(
                      children: [
                        Obx(
                            () => Checkbox(value: controller.rememberMe.value,
                                onChanged: (value) => controller.rememberMe.value = !controller.rememberMe.value
                            ),
                        ),

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

                SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => controller.login(), child: const Text('Войти'))),

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