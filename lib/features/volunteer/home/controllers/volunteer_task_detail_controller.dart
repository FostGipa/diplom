import 'dart:async';
import 'dart:convert';
import 'package:app/data/models/task_model.dart';
import 'package:app/utils/loaders/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../../data/models/user_model.dart';
import '../../../../server/service.dart';

class VolunteerTaskDetailController extends GetxController {
  final ServerService serverService = ServerService();
  Rx<TaskModel?> taskData = Rx<TaskModel?>(null);
  var panelHeight = 0.3.obs;
  Rx<User?> userData = Rx<User?>(null);
  var isLoading = true.obs;
  WebSocketChannel? channel;
  RxString lastMessage = ''.obs;
  final StreamController<String> _messageController = StreamController.broadcast();

  Stream<String> get messageStream => _messageController.stream;

  void getUser() {
    userData.value = serverService.getCachedUser();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    getUser();
    if (userData.value != null) {

    }
    isLoading.value = false;
    update();
  }

  void initWebSocket() {
    if (userData.value?.idUser != null) {
      channel = IOWebSocketChannel.connect('ws://10.0.2.2:8080?userId=${userData.value!.idUser}');
      _listenWebSocket();
    }
  }

  void _listenWebSocket() {
    channel?.stream.listen((message) {
      try {
        final Map<String, dynamic> data = jsonDecode(message);
        if (data['event'] == 'task_completed') {
          lastMessage.value = "Заявка завершена!";
          print("Принята");
          _messageController.add(lastMessage.value);
          _handleTaskCompleted();
        }
      } catch (e) {
        print("Ошибка парсинга WebSocket-сообщения: $e");
      }
    });
  }

  void _handleTaskCompleted() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (Get.isDialogOpen ?? false) Get.back();
      if (Get.currentRoute != '/') Get.back();
      TLoaders.successSnackBar(title: "Успех", message: lastMessage.value);
    });
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
    List<String> parts = taskData.value!.taskCoordinates.split(', ');
    return double.tryParse(parts[0]);
  }

  // Метод для получения долготы
  double? get longitude {
    List<String> parts = taskData.value!.taskCoordinates.split(', ');
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
}