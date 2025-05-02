  import 'package:app/utils/loaders/loaders.dart';
import 'package:flutter/material.dart';
  import 'package:get/get.dart';

  import '../../../../server/service.dart';

  class TaskEditController extends GetxController {
    final ServerService serverService = ServerService();
    final GlobalKey<FormState> secondFormKey = GlobalKey<FormState>();
    final taskName = TextEditingController();
    final taskDescription = TextEditingController();
    final taskComment = TextEditingController();
    final taskVolunteersCount = TextEditingController();
    final taskStartDate = TextEditingController();
    final taskStartTime = TextEditingController();
    final taskAddress = TextEditingController();
    final taskDurationController = TextEditingController();
    RxBool isFormValid = false.obs;
    RxBool isLoading = false.obs;
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    Future<void> loadTaskData(int taskId) async {
      try {
        isLoading.value = true;
        final taskData = await serverService.getTaskById(taskId);

        if (taskData != null) {
          taskName.text = taskData.taskName;
          taskDescription.text = taskData.taskDescription;
          taskComment.text = taskData.taskComment;
          taskVolunteersCount.text = taskData.taskVolunteersCount.toString();
          taskStartDate.text = taskData.taskStartDate;
          taskStartTime.text = taskData.taskStartTime;
          taskAddress.text = taskData.taskAddress;
          taskDurationController.text = taskData.taskDuration;
        }
      } catch (e) {
        print('Ошибка загрузки данных: $e');
      } finally {
        isLoading.value = false;
      }
    }

    void validateForm() {
      isFormValid.value = taskName.text.isNotEmpty &&
          taskDescription.text.isNotEmpty &&
          taskVolunteersCount.text.isNotEmpty &&
          taskDurationController.text.isNotEmpty && // Проверяем контроллер
          taskStartDate.text.isNotEmpty &&
          taskStartTime.text.isNotEmpty &&
          taskAddress.text.isNotEmpty;
    }

    Future<void> updateTask(int taskId) async {
      try {
        isLoading.value = true;

        final response = await serverService.updateTask(
            id: taskId,
            taskName: taskName.text,
            taskDescription: taskDescription.text,
            taskComment: taskComment.text,
            taskVolunteersCount: int.parse(taskVolunteersCount.text),
            taskStartDate: taskStartDate.text,
            taskStartTime: taskStartTime.text,
            taskAddress: taskAddress.text,
            taskDuration: taskDurationController.text,
        );

        if (response == true) {
          Get.back();
          TLoaders.successSnackBar(title: "Успех", message: "Задача успешно обновлена!");
        } else {
          Get.snackbar("Ошибка", "Не удалось обновить задачу.", snackPosition: SnackPosition.BOTTOM);
        }
      } catch (e) {
        print('Ошибка при отправке данных: $e');
        Get.snackbar("Ошибка", "Произошла ошибка при обновлении задачи.", snackPosition: SnackPosition.BOTTOM);
      } finally {
        isLoading.value = false;
      }
    }



    @override
    void onClose() {
      taskDurationController.dispose();
      super.onClose();
    }
  }


