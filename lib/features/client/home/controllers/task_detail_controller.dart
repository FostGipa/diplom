import 'package:app/data/task_model.dart';
import 'package:get/get.dart';

import '../../../../server/service.dart';

class TaskDetailController extends GetxController {
  final ServerService serverService = ServerService();
  Rx<TaskModel?> taskData = Rx<TaskModel?>(null);
  var panelHeight = 0.3.obs;

  void fetchTask(int taskId) async {
    try {
      TaskModel? task = await serverService.getTaskById(taskId);
      taskData.value = task;
    } catch (e) {
      print("Ошибка при получении задачи: $e");
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
}