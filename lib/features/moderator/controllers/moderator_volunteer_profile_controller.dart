import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/task_model.dart';
import '../../../data/models/volunteer_model.dart';
import '../../../server/service.dart';
import '../../../utils/constants/colors.dart';

class ModeratorVolunteerProfileController extends GetxController {
  final ServerService serverService = ServerService();
  var isLoading = true.obs;
  Rx<Volunteer?> volunteerData = Rx<Volunteer?>(null);
  RxList<TaskModel> activeTasks = <TaskModel>[].obs;

  Future<void> fetchVolunteerData(int userId) async {
    try {
      volunteerData.value = await serverService.getVolunteer(userId);
    } catch (e) {
      print("Ошибка при получении данных клиента: $e");
    }
  }

  Future<void> loadData(int userId) async {
    isLoading.value = true;
    await fetchVolunteerData(userId);
    if (volunteerData.value != null) {
      await fetchVolunteerTasks(volunteerData.value!.idVolunteer!);
      activeTasks.refresh();
    }
    isLoading.value = false;
    update();
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
}