import 'package:app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          "Уведомления",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 4,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
        child: const Center(
          child: Text("Список уведомлений пуст", style: TextStyle(fontSize: 24)),
        ),
      ),
    );
  }
}
