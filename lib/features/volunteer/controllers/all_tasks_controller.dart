import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../data/models/task_model.dart';
import '../../../../server/service.dart';

class AllTasksController extends GetxController {
  final ServerService serverService = ServerService();
  var isLoading = true.obs;
  RxList<TaskModel> allTasks = <TaskModel>[].obs;
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final FocusNode searchFocusNode = FocusNode();

  @override
  void onReady() {
    super.onReady();
    loadData();
  }

  Future<void> fetchVolunteerTasks() async {
    try {
      List<TaskModel> tasks = await serverService.getAllTasks();
      allTasks.assignAll(tasks);
    } catch (e) {
      print("Ошибка при получении задач: $e");
    }
  }

  Future<void> loadData() async {
    isLoading.value = true;
    await fetchVolunteerTasks();
    allTasks.refresh();
    isLoading.value = false;
    update();
  }
}