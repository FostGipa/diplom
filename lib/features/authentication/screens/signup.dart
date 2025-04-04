import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:app/common/widgets/custom_text_field.dart';
import 'package:app/utils/constants/sizes.dart';
import 'package:app/utils/loaders/loaders.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/validators/validation.dart';
import '../controllers/signup_controller.dart';

class SignupScreen extends StatefulWidget {
  final String phoneNumber;
  const SignupScreen({super.key, required this.phoneNumber});

  @override
  State<SignupScreen> createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {

  int value = 0;
  late final SignupController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SignupController(phoneNumber: widget.phoneNumber)); // Передаем телефон в контроллер
  }

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

              signupForm(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget signupForm(BuildContext context) {
    return Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Выберите роль", style: Theme.of(context).textTheme.bodyMedium),

            SizedBox(height: TSizes.spaceBtwInputFields),
            // Выбор роли
            SizedBox(
                width: double.infinity,
                child: Obx(() => AnimatedToggleSwitch<int>.size(
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
                  onChanged: (value) => controller.userRole.value = value
                ))
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            Text("Информация о пользователе", style: Theme.of(context).textTheme.bodyMedium),

            SizedBox(height: TSizes.spaceBtwInputFields),

            CustomTextField(
              controller: controller.name,
              validator: (value) => TValidator.validateEmptyText('ФИО', value),
              onChanged: (value) {
                controller.fetchFioSuggestions(value);
              },
              label: "ФИО",
              prefixIcon: Iconsax.user,
            ),

            Obx(() {
              if (controller.fioSuggestions.isEmpty) {
                return SizedBox.shrink();
              }

              return SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: controller.fioSuggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(controller.fioSuggestions[index]),
                      onTap: () {
                        controller.name.text = controller.fioSuggestions[index];
                        controller.fioSuggestions.clear();
                      },
                    );
                  },
                ),
              );
            }),

            SizedBox(height: TSizes.spaceBtwInputFields),

            CustomTextField(
              controller: controller.phone,
              validator: (value) => TValidator.validateEmptyText('Номер телефона', value),
              label: "Номер телефона",
              prefixIcon: Iconsax.external_drive,
              enabled: false,
            ),

            SizedBox(height: TSizes.spaceBtwInputFields),

            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Пол',
                border: OutlineInputBorder(),
              ),
              icon: Icon(Icons.keyboard_arrow_down),
              style: TextStyle(color: Colors.black, fontFamily: 'VK Sans', fontWeight: FontWeight.w500, fontSize: 18),
              items: <String>['Мужской', 'Женский'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                controller.gender.value = value!;
              },
            ),

            SizedBox(height: TSizes.spaceBtwInputFields),

            InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                  locale: Locale('ru', 'RU'),
                );
                if (picked != null && picked != controller.selectedDate) {
                  setState(() {
                    controller.selectedDate = picked;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Iconsax.calendar, color: Colors.grey),
                    SizedBox(width: TSizes.md),
                    Text(
                      controller.selectedDate != null
                          ? DateFormat('d MMMM, y', 'ru_RU').format(controller.selectedDate!)
                          : 'Дата рождения',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),

            Obx(() => AnimatedCrossFade(
              firstChild: Container(),
              secondChild: Column(
                children: [
                  SizedBox(height: TSizes.spaceBtwInputFields),
                  CustomTextField(
                    controller: controller.passport,
                    label: "Серия и номер паспорта",
                    prefixIcon: Iconsax.keyboard,
                    isPassword: false,
                    formatter: controller.formatters.passportFormatter,
                    onSubmitted: (value) {
                      controller.processPassport();
                    },
                  ),
                  SizedBox(height: TSizes.spaceBtwInputFields),
                  CustomTextField(
                    controller: controller.dobroID,
                    label: "ID Добро.ру",
                    prefixIcon: Iconsax.clipboard_text,
                    isPassword: false,
                    formatter: controller.formatters.dobroIdFormatter,
                  ),
                ],
              ),
              crossFadeState: controller.userRole.value == 0
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 300),
              ),
            ),

            SizedBox(height: TSizes.spaceBtwSections),

            termsCheckBox(context),

            SizedBox(height: TSizes.spaceBtwSections),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.formKey.currentState!.validate()) {
                    if (controller.privacyPolicy.value == true) {
                      controller.processFullName();
                      controller.addNewUser();
                    } else {
                      TLoaders.warningSnackBar(title: 'Ошибка', message: 'Примите пользовательское соглашение');
                    }
                  }
                },
                child: Text("Создать аккаунт")))
          ],
        )
    );
  }

  Widget termsCheckBox(BuildContext context) {
    return Row(
      children: [
        Obx(() => Checkbox(
          value: controller.privacyPolicy.value,
          onChanged: (value) => controller.privacyPolicy.value = value ?? false,
        )),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () => controller.privacyPolicy.value = !controller.privacyPolicy.value, // Позволяет нажимать на текст
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Согласен с условиями ',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  TextSpan(
                    text: 'Пользовательского соглашения',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.green,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}