import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';

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

              Text("Выберите роль", style: Theme.of(context).textTheme.bodyMedium),

              SizedBox(height: TSizes.spaceBtwInputFields),
              // Выбор роли
              SizedBox(
                  width: double.infinity,
                  child: AnimatedToggleSwitch<int>.size(
                    textDirection: TextDirection.rtl,
                    current: value,
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
                    onChanged: (i) => setState(() => value = i),
                  )
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              Text("Информация о пользователе", style: Theme.of(context).textTheme.bodyMedium),

              const SizedBox(height: TSizes.spaceBtwInputFields),

              TextFormField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax
                        .user),
                    labelText: 'Фамилия Имя Отчество',
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwInputFields),

              TextFormField(
                decoration: const InputDecoration(labelText: "Номер телефона", prefixIcon: Icon(Iconsax.call)),
              ),

              const SizedBox(height: TSizes.spaceBtwInputFields),

              TextFormField(
                decoration: const InputDecoration(labelText: "Пароль", prefixIcon: Icon(Iconsax.password_check), suffixIcon: Icon(Iconsax.eye_slash)),
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              Row(
                children: [
                  SizedBox(width: 24, height: 24, child: Checkbox(value: true, onChanged: (value) {})),
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
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: const Text("Создать аккаунт")))
            ],
          ),
        ),
      ),
    );
  }
}