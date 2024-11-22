import 'package:app/features/authentication/controllers/signup/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class TTermsCheckBox extends StatelessWidget {
  const TTermsCheckBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instance;
    return Row(
      children: [
        SizedBox(
            width: 24,
            height: 24,
            child: Obx(
                () => Checkbox(
                    value: controller.privacyPolicy.value,
                    onChanged: (value) => controller.privacyPolicy.value = !controller.privacyPolicy.value
                )
            )
        ),
        const SizedBox(width: TSizes.spaceBtwItems),
        Expanded(
          child: Text.rich(
            TextSpan(children: [
              TextSpan(text: 'Согласен с условиями ', style: Theme.of(context).textTheme.bodySmall),
              TextSpan(text: 'Пользовательского соглашения', style: Theme.of(context).textTheme.bodySmall!.apply(
                  color: TColors.green,
                  decoration: TextDecoration.underline,
                  decorationColor: TColors.green
              ))
            ]),
          ),
        )
      ],
    );
  }
}