import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../server/service.dart';
import '../../../utils/constants/sizes.dart';
import '../../volunteer/controllers/volunteer_home_controller.dart';

class QrScannerController extends GetxController {
  final ServerService serverService = ServerService();
  bool _isProcessing = false;

  void endTask(String idTask) async {
    if (_isProcessing) return;
    _isProcessing = true;

    bool success = await serverService.endTask(idTask);
    if (success) {
      Get.back();
      Get.back();
      bool isMainLoaded = false;
      while (!isMainLoaded) {
        try {
          final mainController = Get.find<VolunteerHomeController>();
          if (mainController.isLoading.isFalse) {
            isMainLoaded = true;
          } else {
            await Future.delayed(Duration(milliseconds: 100));
          }
        } catch (_) {
          await Future.delayed(Duration(milliseconds: 100));
        }
      }
      // Показать диалог
      showModalBottomSheet<dynamic>(
          isScrollControlled: true,
          context: Get.context!,
          builder: (BuildContext bc) {
            return Wrap(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      left: TSizes.defaultSpace,
                      right: TSizes.defaultSpace,
                      bottom: TSizes.defaultSpace,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset(
                            'assets/images/success.json',
                            width: 250,
                            height: 250,
                            repeat: true,
                          ),
                          const Text(
                            'Задача завершена!',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'VK Sans'),
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          const Text(
                            textAlign: TextAlign.center,
                            'Спасибо что выбрали сервис ВолонтерGo!',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, fontFamily: 'VK Sans'),
                          ),
                          const SizedBox(height: TSizes.spaceBtwSections),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text("Готово"),
                            ),
                          ),
                          SizedBox(height: 20)
                        ],
                      ),
                    ),
                  ),
                ]
            );
          }
      );

    } else {
      print("Не удалось завершить задачу.");
    }

    _isProcessing = false;
  }
}