import 'package:app/data/models/client_model.dart';
import 'package:app/data/models/volunteer_model.dart';
import 'package:app/utils/formatters/formatter.dart';
import 'package:app/utils/loaders/loaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../server/service.dart';

class SignupController extends GetxController {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final userRole = 1.obs;
  final RxBool privacyPolicy = false.obs;
  final name = TextEditingController();
  final phone = TextEditingController();
  final passport = TextEditingController();
  final dobroID = TextEditingController();
  var addressSuggestions = <String>[].obs;
  final ServerService serverService = ServerService();
  final TFormatters formatters = TFormatters();
  String lastName = '';
  String firstName = '';
  String? middleName = '';
  String series = '';
  String number = '';
  final RxString gender = ''.obs;

  SignupController({required String phoneNumber}) {
    phone.text = phoneNumber;
  }

  void processFullName() {
    try {
      List<String> parts = name.text.trim().split(RegExp(r'\s+')); // Разделяем по пробелам

      if (parts.length < 2) {
        TLoaders.errorSnackBar(title: "Ошибка", message: "Введите как минимум фамилию и имя");
      }

      lastName = parts[0]; // Фамилия
      firstName = parts[1]; // Имя
      middleName = parts.length > 2 ? parts.sublist(2).join(' ') : null; // Отчество, если есть

    } catch (e) {
      print("Ошибка: ${e.toString()}");
    }
  }

  void processPassport() {
    try {
      // Убираем пробелы и проверяем на соответствие шаблону
      String passportData = passport.text.trim();
      RegExp regExp = RegExp(r'^\d{4} \d{6}$');

      if (!regExp.hasMatch(passportData)) {
        throw Exception("Неверный формат паспорта. Формат: 1234 123456");
      }

      series = passportData.substring(0, 4); // Первая часть (серия)
      number = passportData.substring(5); // Вторая часть (номер)

      print("Серия: $series, Номер: $number");
    } catch (e) {
      print("Ошибка: ${e.toString()}");
    }
  }


  void fetchFioSuggestions(String query) async {
    if (query.isEmpty) {
      addressSuggestions.clear();
      return;
    }

    final fetchedSuggestions = await serverService.fetchFioSuggestions(query);
    if (fetchedSuggestions != null) {
      addressSuggestions.value = fetchedSuggestions;
    }
  }

  void addNewVolunteer() async {
    if (userRole.value == 0) {
      serverService.addVolunteer(
          Volunteer(
              phoneNumber: phone.text,
              lastName: lastName,
              name: firstName,
              middleName: middleName,
              gender: gender.value,
              passportSerial: series,
              passportNumber: number,
              dobroId: dobroID.text
          )
      );
    } else {
      serverService.addClient(
        Client(
            lastName: lastName,
            name: firstName,
            middleName: middleName,
            gender: gender.value,
            phoneNumber: phone.text
        )
      );
    }
  }
}