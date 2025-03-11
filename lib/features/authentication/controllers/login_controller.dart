import 'package:app/client_navigation_menu.dart';
import 'package:app/data/models/user_model.dart';
import 'package:app/server/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/formatters/formatter.dart';

class LoginController extends GetxController {
  final PageController pageController = PageController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final RxString phoneNumber = ''.obs;
  final RxInt currentPage = 0.obs;
  final RxString? receivedOtp = ''.obs;
  final RxInt resendTimer = 30.obs;
  final RxBool canResend = false.obs;
  final TFormatters formatters = TFormatters();
  final ServerService serverService = ServerService();

  void nextPage() {
    if (currentPage.value == 0) {
      pageController.animateToPage(1,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut);
      currentPage.value = 1;
    }
  }

  void previousPage() {
    if (currentPage.value == 1) {
      pageController.animateToPage(0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut);
      currentPage.value = 0;
    }
  }

  Future<void> sendOtp() async {
    String formattedPhone = phoneController.text.replaceAll(RegExp(r'\D'), '');
    if (formattedPhone.length == 11) {
      ServerService serverService = ServerService();
      String? otp = await serverService.sendOtp(formattedPhone);
      if (otp != null) {
        receivedOtp?.value = otp; // Сохраняем полученный OTP
        print("Полученный OTP: $otp");
      } else {
        print("Ошибка при получении OTP");
      }
    } else {
      print("Некорректный номер телефона");
    }
  }

  void startResendTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (resendTimer > 0){
        resendTimer.value--;
        startResendTimer();
      } else {
        canResend.value = true;
      }
    });
  }

  void pinCompleted(String phoneNumber) async {
    final User user  = await serverService.getUser(phoneController.text) as User;
    print(user.role);
    if (user.role == "Клиент") {
      Get.offAll(ClientNavigationMenu());
    }
  }
}