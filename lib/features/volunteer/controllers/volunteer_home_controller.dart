import 'dart:async';
import 'package:app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/task_model.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/models/volunteer_model.dart';
import '../../../../server/service.dart';

class VolunteerHomeController extends GetxController {
  final ServerService serverService = ServerService();
  Rx<Volunteer?> volunteerData = Rx<Volunteer?>(null);
  Rx<User?> userData = Rx<User?>(null);
  RxList<TaskModel> activeTasks = <TaskModel>[].obs;
  var isLoading = true.obs;
  int currentIndex = 0;
  late Timer timer;
  final PageController pageController = PageController();

  @override
  void onReady() {
    super.onReady();
    loadData();
  }

  Future<void> fetchVolunteerData(int userId) async {
    try {
      volunteerData.value = await serverService.getVolunteer(userId);
    } catch (e) {
      print("Ошибка при получении данных клиента: $e");
    }
  }

  Future<void> fetchVolunteerTasks(int volunteerId) async {
    try {
      List<TaskModel> tasks = await serverService.getVolunteerTasks(volunteerId);
      activeTasks.assignAll(tasks);
    } catch (e) {
      print("Ошибка при получении задач: $e");
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Завершена":
        return TColors.green;
      case "Отменен":
        return TColors.failed;
      default:
        return Colors.grey;
    }
  }

  void getUser() {
    userData.value = serverService.getCachedUser();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    getUser();
    if (userData.value != null) {
      await fetchVolunteerData(userData.value!.idUser!);
      if (volunteerData.value != null) {
        await fetchVolunteerTasks(volunteerData.value!.idVolunteer!);
        activeTasks.refresh();
      }
    }
    isLoading.value = false;
    update();
  }
}
