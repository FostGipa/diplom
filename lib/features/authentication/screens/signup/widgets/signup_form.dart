import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:app/features/authentication/screens/signup/widgets/signup_terms_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../controllers/signup/signup_controller.dart';

class TSignupForm extends StatefulWidget {
  const TSignupForm({super.key});

  @override
  State<StatefulWidget> createState() => TSignupFormWidget();
}

class TSignupFormWidget extends State<TSignupForm> {

  int value = 0;

  // Маска на паспорт
  final MaskTextInputFormatter passportFormatter = MaskTextInputFormatter(
    mask: '#### ######',
    filter: {"#": RegExp(r'[0-9A-Z]')},
  );

  // Маска на DobroID
  final MaskTextInputFormatter dobroIdFormatter = MaskTextInputFormatter(
    mask: '######',
    filter: {"#": RegExp(r'[0-9A-Z]')},
  );

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Form(
      key: controller.signupFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Выберите роль", style: Theme.of(context).textTheme.bodyMedium),

          SizedBox(height: TSizes.spaceBtwInputFields),
          // Выбор роли
          SizedBox(
              width: double.infinity,
              child: Obx(
                  () => AnimatedToggleSwitch<int>.size(
                    textDirection: TextDirection.rtl,
                    current: controller.userRole.value,
                    values: const [0, 1],
                    iconOpacity: 1,
                    selectedIconScale: 1.0,
                    indicatorSize: const Size.fromWidth(200),
                    borderWidth: 4.0,
                    height: 55,
                    iconAnimationType: AnimationType.onHover,
                    style: ToggleStyle(
                      borderColor: Colors.transparent,
                      backgroundColor: Colors.white,
                      indicatorColor: TColors.green,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 1.5),
                        ),
                      ],
                    ),
                    customIconBuilder: (context, local, global) {
                      final icons = const [FontAwesomeIcons.handHoldingMedical, FontAwesomeIcons.personWalkingWithCane][local.index];
                      final texts = const ["Волонтер", "Клиент"] [local.index];
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(icons, color: Color.lerp(TColors.black, Colors.white,
                                local.animationValue)),

                            SizedBox(width: 10),

                            Text(texts, style: TextStyle.lerp(TextStyle(color: TColors.black, fontSize: 18, fontWeight: FontWeight.w500), TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500), local.animationValue))
                          ]);
                    },
                    onChanged: (value) => setState(() => controller.userRole.value = value),
                  )
              )
          ),

          const SizedBox(height: TSizes.spaceBtwSections),

          Text("Информация о пользователе", style: Theme.of(context).textTheme.bodyMedium),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          TextFormField(
            controller: controller.name,
            validator: (value) => TValidator.validateEmptyText('ФИО', value),
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax
                  .user),
              labelText: 'Фамилия Имя Отчество',
            ),
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          TextFormField(
            controller: controller.email,
            validator: (value) => TValidator.validateEmail(value),
            decoration: const InputDecoration(labelText: "Почта", prefixIcon: Icon(Iconsax.direct)),
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          IntlPhoneField(
            controller: controller.phone,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: Icon(Iconsax.call),
            ),
            initialCountryCode: 'RU',

          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

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

          Obx(
                () => AnimatedCrossFade(
              firstChild: Container(),
              secondChild: Column(
                children: [
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                  TextFormField(
                    controller: controller.passport,
                    inputFormatters: [passportFormatter],
                    decoration: const InputDecoration(labelText: "Серия и номер паспорта", prefixIcon: Icon(Iconsax.keyboard)),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                  TextFormField(
                    controller: controller.dobroID,
                    inputFormatters: [dobroIdFormatter],
                    decoration: const InputDecoration(labelText: "ID Добро.ру", prefixIcon: Icon(Iconsax.clipboard_text)),
                  ),
                ],
              ),
              crossFadeState: controller.userRole.value == 0
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 300),
            ),
          ),

          const SizedBox(height: TSizes.spaceBtwSections),

          TTermsCheckBox(),

          const SizedBox(height: TSizes.spaceBtwSections),

          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => controller.signup(), child: const Text("Создать аккаунт")))
        ],
      )
    );
  }
}
