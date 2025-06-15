import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/task_model.dart';
import '../../../server/service.dart';

class ModeratorHomeController extends GetxController {
  final ServerService serverService = ServerService();
  var totalTasks = 0.obs;
  var activeTasks = 0.obs;
  var newTasksInPeriod = 0.obs;
  var rejectedTasks = 0.obs;
  var isLoading = true.obs;

  DateTimeRange? selectedDateRange = DateTimeRange(
    start: DateTime.now().subtract(Duration(days: 7)),
    end: DateTime.now(),
  );

  @override
  void onInit() {
    super.onInit();
    getAllTasks();
  }

  Future<void> getAllTasks() async {
    isLoading.value = true;

    try {
      final tasks = await serverService.getAllTasks();
      _updateStatistics(tasks);
    } catch (e) {
      print("Ошибка при получении задач: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDateRange(DateTimeRange newRange) async {
    selectedDateRange = newRange;
    await getAllTasks();
  }

  void _updateStatistics(List<TaskModel> tasks) {
    List<TaskModel> filteredTasks = selectedDateRange != null
        ? tasks.where((task) => task.isInDateRange(selectedDateRange!)).toList()
        : tasks;

    totalTasks.value = filteredTasks.length;
    activeTasks.value = filteredTasks
        .where((task) => task.taskStatus == 'В процессе' || task.taskStatus == 'Создана')
        .length;
    rejectedTasks.value = filteredTasks
        .where((task) => task.taskStatus == 'Отменена')
        .length;
    newTasksInPeriod.value = filteredTasks.length;
  }

  Future<List<int>> getWeeklyTasksCount() async {
    final now = DateTime.now();

    // Получаем дату понедельника прошлой недели
    final startOfLastWeek = now.subtract(Duration(days: now.weekday - 1 + 7));

    // Создаем список из 7 дней прошлой недели (ПН-ВС)
    final lastWeekDays = List.generate(7, (index) {
      return startOfLastWeek.add(Duration(days: index));
    });

    final tasks = await serverService.getAllTasks();

    return lastWeekDays.map((day) {
      return tasks.where((task) {
        try {
          final taskDate = DateFormat('yyyy-MM-dd').parse(task.taskStartDate);
          return taskDate.year == day.year &&
              taskDate.month == day.month &&
              taskDate.day == day.day;
        } catch (e) {
          print('Error parsing date: ${task.taskStartDate}');
          return false;
        }
      }).length;
    }).toList();
  }
}

extension DateFiltering on TaskModel {
  bool isInDateRange(DateTimeRange range) {
    try {
      DateTime taskDate = DateFormat('yyyy-MM-dd').parse(this.taskStartDate);
      return taskDate.isAfter(range.start.subtract(Duration(days: 1))) &&
          taskDate.isBefore(range.end.add(Duration(days: 1)));
    } catch (e) {
      print('Ошибка парсинга даты: $e');
      return false;
    }
  }
}
