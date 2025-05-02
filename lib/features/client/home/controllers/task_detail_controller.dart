import 'dart:async';
import 'dart:convert';
import 'package:app/data/models/task_model.dart';
import 'package:app/utils/loaders/loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/models/volunteer_model.dart';
import '../../../../server/service.dart';
import '../../../../utils/constants/sizes.dart';
import 'client_home_controller.dart';

class TaskDetailController extends GetxController {
  final ServerService serverService = ServerService();
  Rx<TaskModel?> taskData = Rx<TaskModel?>(null);
  var panelHeight = 0.3.obs;
  Rx<User?> userData = Rx<User?>(null);
  var isLoading = true.obs;
  WebSocketChannel? channel;
  RxString lastMessage = ''.obs;
  final StreamController<String> _messageController = StreamController.broadcast();
  bool isModalShown = false;

  Stream<String> get messageStream => _messageController.stream; // Поток сообщений

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
      channel = IOWebSocketChannel.connect('ws://80.78.243.244:3000?userId=${userData.value!.idUser}');
      _listenWebSocket();
    }
  }

  void _listenWebSocket() {
    channel?.stream.listen((message) {
      try {
        final Map<String, dynamic> data = jsonDecode(message);
        if (data['event'] == 'task_completed') {
          lastMessage.value = "Заявка завершена!";
          _messageController.add(lastMessage.value);
          _handleTaskCompleted();
        }
      } catch (e) {
        print("Ошибка парсинга WebSocket-сообщения: $e");
      }
    });
  }

  void _handleTaskCompleted() {
    Future.delayed(Duration(milliseconds: 100), () async {
      if (Get.isDialogOpen ?? false) Get.back();
      if (Get.currentRoute != '/') Get.back();

      await Future.delayed(Duration(milliseconds: 200));

      bool isMainLoaded = false;
      while (!isMainLoaded) {
        try {
          final mainController = Get.find<ClientHomeController>();
          if (mainController.isLoading.isFalse) {
            isMainLoaded = true;
          } else {
            await Future.delayed(Duration(milliseconds: 100));
          }
        } catch (_) {
          await Future.delayed(Duration(milliseconds: 100));
        }
      }
      if (!isModalShown) {
        isModalShown = true;
        showModalBottomSheet(
          isScrollControlled: true,
          context: Get.context!,
          builder: (BuildContext bc) {
            return Wrap(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      left: TSizes.defaultSpace,
                      right: TSizes.defaultSpace,
                      bottom: TSizes.defaultSpace,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset(
                            'assets/images/success.json',
                            width: 250,
                            height: 250,
                            repeat: true,
                          ),
                          const Text(
                            'Задача завершена!',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'VK Sans'),
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          const Text(
                            textAlign: TextAlign.center,
                            'Спасибо что выбрали сервис ВолонтерGo!',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, fontFamily: 'VK Sans'),
                          ),
                          const SizedBox(height: TSizes.spaceBtwSections),

                          // Рейтинг волонтера
                          const Text(
                            'Оцените волонтёра',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, fontFamily: 'VK Sans'),
                          ),
                          const SizedBox(height: 12),
                          RatingBar.builder(
                            initialRating: 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              rateVolunteer(taskData.value!.id!, rating);
                              print('Оценка: $rating');
                            },
                          ),

                          const SizedBox(height: TSizes.spaceBtwSections),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text("Готово"),
                            ),
                          ),
                          SizedBox(height: 20)
                        ],
                      ),
                    ),
                  ),
                ]
            );
          },
        ).whenComplete(() {
          isModalShown = false; // Сбрасываем флаг, когда модалка закрывается
        });
      }
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

  Future<void> rateVolunteer(int id, double rating) async {
    await serverService.updateVolunteerRating(id, rating);
  }

  Future<void> cancelTask(int taskId) async {
    await serverService.cancelTask(taskId);
  }

  int getVolunteersCount(List<Volunteer> volunteers) {
    if (volunteers.isEmpty) {
      return 0;
    }
    // Отфильтровать тех, кто реально валидный (если нужно)
    final realVolunteers = volunteers.where((v) => v.idVolunteer != 0).toList();

    return realVolunteers.length;
  }
}