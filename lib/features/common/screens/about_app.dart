import 'package:app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({super.key});

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(onPressed: Get.back, icon: Icon(Iconsax.arrow_left_2)),
        title: Text('О приложении', style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 24,
        )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', width: 150, height: 150),
              SizedBox(height: TSizes.spaceBtwSections),
              Text('ВолонтерGo', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              SizedBox(height: TSizes.spaceBtwSections),
              Text('Это приложение создано для упрощения взаимодействия между людьми, нуждающимися в помощи, и волонтёрами, готовыми её оказать.\n'
                  'Наша цель — сделать процесс помощи быстрым, прозрачным и доступным каждому.\n'
                  'Мы верим, что технологии могут объединять людей и делать добрые дела проще.\n', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
              SizedBox(height: TSizes.xs),
              Text('Версия приложения: 1.0.0\n'
                  'Разработано с заботой и энтузиазмом ❤️', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            ],
          )),
      ),
    );
  }
}
