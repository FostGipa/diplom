import 'package:get/get.dart';
import 'package:app/data/models/client_model.dart';
import '../../../../data/task_model.dart';
import '../../../../server/service.dart';

class ClientHomeController extends GetxController {
  final ServerService serverService = ServerService();
  Rx<Client?> clientData = Rx<Client?>(null);
  RxList<TaskModel> activeTasks = <TaskModel>[].obs;

  // Метод для загрузки данных о клиенте
  void fetchClientData(int userId) async {
    try {
      clientData.value = await serverService.getClient(userId); // Получаем данные клиента
    } catch (e) {
      // Обработка ошибок
      print("Ошибка при получении данных клиента: $e");
    }
  }

  void fetchClientTasks(int clientId) async {
    try {
      List<TaskModel> tasks = await serverService.getClientTasks(clientId);
      activeTasks.assignAll(tasks); // Обновляем список активных заявок
    } catch (e) {
      print("Ошибка при получении задач клиента: $e");
    }
  }
}
