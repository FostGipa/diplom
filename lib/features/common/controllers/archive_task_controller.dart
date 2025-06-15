import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../data/models/task_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/volunteer_model.dart';
import '../../../server/service.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/loaders/loaders.dart';

class ArchiveTaskController extends GetxController {
  final ServerService serverService = ServerService();
  Rx<TaskModel?> taskData = Rx<TaskModel?>(null);
  var panelHeight = 0.3.obs;
  Rx<User?> userData = Rx<User?>(null);
  var isLoading = true.obs;
  WebSocketChannel? channel;
  RxString lastMessage = ''.obs;
  bool isModalShown = false;

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

  @override
  void onClose() {
    channel?.sink.close();
    super.onClose();
  }

  void fetchTask(int taskId) async {
    try {
      TaskModel? task = await serverService.getTaskById(taskId);
      taskData.value = task;
      Future.delayed(Duration.zero, checkAndShowReviewSheet);
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

  Color getStatusColor(String status) {
    switch (status) {
      case "Завершена":
        return TColors.green;
      case "Отменена":
        return TColors.failed;
      default:
        return Colors.grey;
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

  int getVolunteersCount(List<Volunteer> volunteers) {
    if (volunteers.isEmpty) {
      return 0;
    }
    // Отфильтровать тех, кто реально валидный (если нужно)
    final realVolunteers = volunteers.where((v) => v.idVolunteer != 0).toList();

    return realVolunteers.length;
  }

  void checkAndShowReviewSheet() {
    if (taskData.value?.taskStatus == 'Завершена' && userData.value?.role == 'Волонтер') {
      final storage = GetStorage();
      final key = 'review_shown_${taskData.value?.id}';
      final alreadyShown = storage.read(key) ?? false;

      if (!alreadyShown) {
        storage.write(key, true); // помечаем как показанное
        showReviewBottomSheet();
      }
    }
  }

  void showReviewBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Оцените клиента',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
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
                rateClient(taskData.value!.id!, rating);
              },
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back(); // Закрыть bottom sheet
                },
                child: Text('Отправить'),
              ),
            )
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> rateClient(int id, double rating) async {
    await serverService.updateClientRating(id, rating);
  }
}