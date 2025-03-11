import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yandex_maps_mapkit/init.dart' as init;


Future<void> main() async {

  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await GetStorage.init();

  await init.initMapkit(
      apiKey: '15f1c5e6-b50b-49f5-a491-57f675d736e7'
  );

  FlutterNativeSplash.remove();

  runApp(const App());
}
