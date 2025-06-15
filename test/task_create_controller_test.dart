import 'package:app/features/client/home/controllers/task_create_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  late TaskCreateController controller;
  setUp(() {
    controller = TaskCreateController();
    Get.put(controller);
  });
  tearDown(() {
    Get.reset();
  });
  group('Валидация второго шага (данные заявки)', () {
    test('Проверка: количество волонтеров = 0 — валидация неуспешна', () {
      controller.taskName.text = 'Помощь';
      controller.taskDescription.text = 'Описание';
      controller.taskVolunteersCount.text = '0';
      controller.taskDuration.text = '1:00';
      controller.validateSecondPage();
      expect(controller.isSecondPageValid.value, false);
    });
    test('Проверка: одно из обязательных полей пустое — валидация неуспешна', () {
      controller.taskName.text = '';
      controller.taskDescription.text = 'Описание';
      controller.taskVolunteersCount.text = '1';
      controller.taskDuration.text = '1:00';
      controller.validateSecondPage();
      expect(controller.isSecondPageValid.value, false);
    });
  });

  /// Тестирование валидации третьего шага формы (контактная информация)
  group('Валидация третьего шага (контактная информация и дата/время)', () {
    test('Проверка: поле ФИО пустое — валидация неуспешна', () {
      controller.fullName.text = '';
      controller.phoneController.text = '+7 (999) 123-45-67';
      controller.taskAddress.text = 'г. Москва, ул. Ленина, д. 1';
      controller.selectedDate = DateTime.now().add(Duration(days: 1));
      controller.selectedTime = const TimeOfDay(hour: 10, minute: 0);

      controller.validateThirdPage();

      expect(controller.isThirdPageValid.value, false);
    });

    test('Проверка: поле адреса не заполнено — валидация неуспешна', () {
      controller.fullName.text = 'Мария Петрова';
      controller.phoneController.text = '+7 (912) 345-67-89';
      controller.taskAddress.text = '';
      controller.selectedDate = DateTime.now().add(Duration(days: 1));
      controller.selectedTime = const TimeOfDay(hour: 9, minute: 15);

      controller.validateThirdPage();

      expect(controller.isThirdPageValid.value, false);
    });
  });
}

