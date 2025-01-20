import 'package:app/client_navigation_menu.dart';
import 'package:app/features/authentication/authentication_repository.dart';
import 'package:app/volunteer_navigation_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../data/firebase_service.dart';
import '../../../../utils/loaders/loaders.dart';
import '../../../../utils/network/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';

class LoginController extends GetxController {
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final FirebaseService _firebaseService = FirebaseService();

  Future<void> login() async {
    try {
      TFullScreenLoader.openLoadingDialog('Получаем информацию...', 'assets/images/success.json');

      // Проверка подключения к интернету
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Валидация формы
      if (!loginFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      } else {
        localStorage.remove('REMEMBER_ME_EMAIL');
        localStorage.remove('REMEMBER_ME_PASSWORD');
      }

      final userCredential = await AuthenticationRepository.instance.loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      localStorage.write('UID', userCredential.user!.uid);

      TFullScreenLoader.stopLoading();

      TLoaders.successSnackBar(title: 'Успешно', message: 'Успешный вход в аккаунт');

      try {
        // Await the future to get the role
        String role = await _firebaseService.getUserById(userCredential.user!.uid);
        print(role.toString());
        if (role == 'Волонтер') {
          Get.offAll(const VolunteerNavigationMenu());
        } else {
          Get.offAll(const ClientNavigationMenu());
        }
      } catch (e) {
        print(e.toString());
      }

    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Ошибка!', message: e.toString());
    }
  }
}