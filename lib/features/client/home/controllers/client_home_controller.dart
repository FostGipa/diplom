import 'dart:async';
import 'package:app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/data/models/client_model.dart';
import '../../../../data/models/task_model.dart';
import '../../../../data/models/user_model.dart';
import '../../../../server/service.dart';

class ClientHomeController extends GetxController {
  final ServerService serverService = ServerService();
  Rx<Client?> clientData = Rx<Client?>(null);
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

  Future<void> fetchClientData(int userId) async {
    try {
      clientData.value = await serverService.getClient(userId);
    } catch (e) {
      print("Ошибка при получении данных клиента: $e");
    }
  }

  Future<void> fetchClientTasks(int clientId) async {
    try {
      List<TaskModel> tasks = await serverService.getClientTasks(clientId);
      activeTasks.assignAll(tasks);
      print(activeTasks.length);
    } catch (e) {
      print("Ошибка при получении задач клиента: $e");
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

  void getUser() {
    userData.value = serverService.getCachedUser();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    getUser();
    if (userData.value != null) {
      await fetchClientData(userData.value!.idUser!);
      if (clientData.value != null) {
        await fetchClientTasks(clientData.value!.idClient!);
        activeTasks.refresh();
      }
    }

    isLoading.value = false;
    update();
  }
}
