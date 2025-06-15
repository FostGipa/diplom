import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../data/models/task_model.dart';
import '../../../server/service.dart';

class ModeratorTasksController extends GetxController {
  final ServerService serverService = ServerService();
  var totalTasks = <TaskModel>[].obs; // Список всех заявок
  var isLoading = true.obs;
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final FocusNode searchFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    getAllTasks();
  }

  // Метод для получения всех заявок
  Future<void> getAllTasks() async {
    isLoading.value = true;

    try {
      final tasks = await serverService.getAllTasks(); // Получаем все задачи

      // Обновляем список заявок
      totalTasks.value = tasks;

    } catch (e) {
      print("Ошибка при получении задач: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
