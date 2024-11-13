import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TDeviceUtils {
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
  
  static Future<void> setStatusBarColor(Color color) async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: color),
    );
  }
  
  static double getScreenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  static double getScreenWight(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getPixelRatio() {
    return MediaQuery.of(Get.context!).devicePixelRatio;
  }

  static double getStatusBarHeight() {
    return MediaQuery.of(Get.context!).padding.top;
  }

  // static double getBottomNavigationBarHeight(BuildContext context) {
  //   return kToolbarHeight;
  // }

  static double getKeyboardHeight() {
    final viewInsets = MediaQuery.of(Get.context!).viewInsets;
    return viewInsets.bottom;
  }

  static Future<bool> isKeyboardVisible(BuildContext context) async {
    final viewInsets = MediaQuery.of(context).viewInsets;
    return viewInsets.bottom > 0;
  }

  static void vibrate(Duration duration) {
    HapticFeedback.vibrate();
    Future.delayed(duration, () => HapticFeedback.vibrate());
  }

  static Future<void> setPreferredOrientations(List<DeviceOrientation> orientations) async {
    await SystemChrome.setPreferredOrientations(orientations);
  }

  static void hideStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  static void showStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }

  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  static void launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}