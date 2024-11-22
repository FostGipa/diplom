import 'package:app/features/authentication/screens/login/login.dart';
import 'package:app/features/volunteer/home/screens/home.dart';
import 'package:app/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../utils/popups/full_screen_loader.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  final localStorage = GetStorage();

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  void screenRedirect() async {
    final rememberMeEmail = localStorage.read('REMEMBER_ME_EMAIL');
    final rememberMePassword = localStorage.read('REMEMBER_ME_PASSWORD');

    if (rememberMeEmail != null && rememberMePassword != null) {
      TFullScreenLoader.openLoadingDialog('Авторизация...', 'assets/images/success.json');
      try {
        await _auth.signInWithEmailAndPassword(
          email: rememberMeEmail,
          password: rememberMePassword,
        );
        TFullScreenLoader.stopLoading();
        Get.offAll(const HomeScreen());
      } catch (e) {
        TFullScreenLoader.stopLoading();
        localStorage.remove('REMEMBER_ME_EMAIL');
        localStorage.remove('REMEMBER_ME_PASSWORD');
        Get.offAll(const LoginScreen());
      }
    } else {
      Get.offAll(const LoginScreen());
    }
  }
  // Регистрация
  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } catch (e) {
      throw 'Что-то пошло не так.';
    }
  }

  // Авторизация
  Future<UserCredential> loginWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } catch (e) {
      throw 'Что-то пошло не так.';
    }
  }
}