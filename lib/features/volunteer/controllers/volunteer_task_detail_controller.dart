import 'dart:async';
import 'package:app/data/models/task_model.dart';
import 'package:app/utils/loaders/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/models/volunteer_model.dart';
import '../../../../server/service.dart';

class VolunteerTaskDetailController extends GetxController {
  ServerService serverService = ServerService();
  Rx<TaskModel?> taskData = Rx<TaskModel?>(null);
  var panelHeight = 0.3.obs;
  Rx<User?> userData = Rx<User?>(null);
  var isLoading = true.obs;
  WebSocketChannel? channel;
  RxString lastMessage = ''.obs;
  final StreamController<String> _messageController = StreamController.broadcast();
  Rx<Volunteer?> volunteerData = Rx<Volunteer?>(null);
  var volunteers = <Volunteer>[].obs;
  Stream<String> get messageStream => _messageController.stream;

  void getUser() {
    userData.value = serverService.getCachedUser();
  }

  Future<void> fetchVolunteerData(int userId) async {
    try {
      volunteerData.value = await serverService.getVolunteer(userId);
    } catch (e) {
      print("Ошибка при получении данных клиента: $e");
    }
  }

  Future<void> loadData() async {
    isLoading.value = true;
    getUser();
    if (userData.value != null) {
      await fetchVolunteerData(userData.value!.idUser!);
    }
    isLoading.value = false;
    update();
  }

  @override
  void onClose() {
    channel?.sink.close();
    super.onClose();
  }

  void fetchTask(int taskId) async {
    try {
      TaskModel? task = await serverService.getTaskById(taskId);
      taskData.value = task;
      loadVolunteers();
    } catch (e) {
      print("Ошибка при получении задачи: $e");
    }
  }

  void openPdfUrl(int dobroId) async {
    try {
      launchUrlString("https://dobro.ru/volunteers/$dobroId/resume");
    } catch (e) {
      TLoaders.errorSnackBar(title: "Ошибка!", message: "Ошибка открытия ЛВК");
    }
  }

  // Метод для получения широты
  double? get latitude {
    List<String> parts = taskData.value!.taskCoordinates.split(',');
    return double.tryParse(parts[0]);
  }

  // Метод для получения долготы
  double? get longitude {
    List<String> parts = taskData.value!.taskCoordinates.split(',');
    return double.tryParse(parts[1]);
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    launchUrlString("tel://+$phoneNumber");
  }

  void openYandexMaps(double latitude, double longitude) async {

    final Uri url = Uri.parse("yandexmaps://maps.yandex.ru/?pt=$longitude,$latitude&z=15");

    if (!await launchUrl(url)) {
      throw 'Не удалось открыть Яндекс.Карты';
    }
  }

  Future<void> generateQRCode() async {
    Get.dialog(AlertDialog(
      title: Text("Подтвердите завершение"),
      content: QrImageView(
        data: 'orderId',
        version: QrVersions.auto,
        size: 200.0,
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text("Закрыть"))
      ],
    ));
  }

  String formatDate(String dateString) {
    try {
      // Преобразуем строку в DateTime
      DateTime date = DateFormat('yyyy-M-d').parse(dateString);

      // Форматируем в "30 марта 2025"
      return DateFormat('d MMMM yyyy', 'ru_RU').format(date);
    } catch (e) {
      return 'Некорректная дата';
    }
  }

  Future<void> acceptTask(int idTask, int idVolunteer) async {
    bool success = await serverService.acceptRequest(idTask, idVolunteer);
    if (success) {
      fetchTask(idTask);
      print("Заявка успешно принята!");
    } else {
      print("Не удалось принять заявку.");
    }
  }

  void loadVolunteers() async {
    final data = taskData.value?.volunteers;
    volunteers.value = data ?? [];
  }

  int getVolunteersCount(List<Volunteer> volunteers) {
    if (volunteers.isEmpty) {
      return 0;
    }
    // Отфильтровать тех, кто реально валидный (если нужно)
    final realVolunteers = volunteers.where((v) => v.idVolunteer != 0).toList();

    return realVolunteers.length;
  }

  void cancelParticipation() async {
    isLoading.value = true;

    final success = await serverService.cancelVolunteerParticipation(taskData.value!.id!, volunteerData.value!.idVolunteer!);

    isLoading.value = false;

    if (success) {
      TLoaders.successSnackBar(title: 'Успешно', message: 'Вы отказались от выполнения задачи');
      Get.back();
    } else {
      Get.snackbar('Ошибка', 'Не удалось отменить участие');
    }
  }
}