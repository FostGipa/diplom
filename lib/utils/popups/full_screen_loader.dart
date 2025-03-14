import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../loaders/amimation_loader.dart';

class TFullScreenLoader {
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Container(
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 250),
              TAnimationWidget(text: text, animation: animation),
            ],
          ),
        )
      )
    );
  }

  static stopLoading() {
    Navigator.of(Get.overlayContext!).pop();
  }
}