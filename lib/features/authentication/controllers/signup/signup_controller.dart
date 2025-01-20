import 'package:app/client_navigation_menu.dart';
import 'package:app/data/user/client_model.dart';
import 'package:app/data/user/user_repository.dart';
import 'package:app/data/user/volunteer_model.dart';
import 'package:app/features/authentication/authentication_repository.dart';
import 'package:app/volunteer_navigation_menu.dart';
import 'package:app/utils/loaders/loaders.dart';
import 'package:app/utils/network/network_manager.dart';
import 'package:app/utils/popups/full_screen_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  final localStorage = GetStorage();

  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final email = TextEditingController();
  final name = TextEditingController();
  final password = TextEditingController();
  final phone = TextEditingController();
  final passport = TextEditingController();
  final dobroID = TextEditingController();
  final userRole = 0.obs;
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  void signup() async {
    try {
      TFullScreenLoader.openLoadingDialog('Получаем информацию...', 'assets/images/success.json');

      // Проверка подключения к интернету
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Валидация формы
      if (!signupFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Проверка галочки
      if (!privacyPolicy.value) {
        TFullScreenLoader.stopLoading();
        TLoaders.warningSnackBar(
          title: 'Примите пользовательское соглашение',
          message: 'Чтобы зарегистрироваться, вы должны принять пользовательское соглашение'
        );
        return;
      }

      // Регистрация пользователя
      final userCredential = await AuthenticationRepository.instance.registerWithEmailAndPassword(email.text.trim(), password.text.trim());

      List<String> parts = name.text.trim().split(' ');

      final userRepository = Get.put(UserRepository());
      if (userRole.value == 1) {
        final newUser = ClientModel(
          id: userCredential.user!.uid,
          firstName: parts[1],
          lastName: parts[0],
          middleName: parts[2],
          email: email.text.trim(),
          phoneNumber: phone.text.trim()
        );
        await userRepository.saveClientRecord(newUser);
        await userRepository.saveUserRecord(userCredential.user!.uid, 'Клиент');
      } else {
        final newUser = VolunteerModel(
          id: userCredential.user!.uid,
          firstName: parts[1],
          lastName: parts[0],
          middleName: parts[2],
          email: email.text.trim(),
          phoneNumber: phone.text.trim(),
          passport: passport.text.trim(),
          dobroId: dobroID.text.trim(),
        );
        await userRepository.saveVolunteerRecord(newUser);
        await userRepository.saveUserRecord(userCredential.user!.uid, 'Волонтер');
      }

      localStorage.write('UID', userCredential.user!.uid);

      TFullScreenLoader.stopLoading();

      TLoaders.successSnackBar(title: 'Успешно', message: 'Ваш аккаунт успешно зарегестрирован');

      if (userRole.value == 2) {
        Get.offAll(const VolunteerNavigationMenu());
      } else {
        Get.offAll(const ClientNavigationMenu());
      }

    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Ошибка!', message: e.toString());
    }
  }
}