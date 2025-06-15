import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:yandex_maps_mapkit/init.dart' as init;


Future<void> main() async {
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await GetStorage.init();
  await init.initMapkit(apiKey: '15f1c5e6-b50b-49f5-a491-57f675d736e7');
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("0f9bc5a7-5f0a-43c4-8227-cd50d7e47637");
  OneSignal.Notifications.requestPermission(true);
  OneSignal.Notifications.addClickListener((event) {
    final data = event.notification.additionalData;
    if (data != null) {
      final action = data['action'];
      final taskId = data['taskId'];
      if (action == 'volunteers_missing' && taskId != null) {
        Future.delayed(Duration.zero, () {
          Get.snackbar('Ошибка', 'Недостаточно волонтеров');
  });}}});
  FlutterNativeSplash.remove();
  runApp(const App());
}


