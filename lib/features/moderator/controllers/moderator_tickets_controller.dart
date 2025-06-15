import 'package:get/get.dart';

import '../../../server/service.dart';

class ModeratorTicketsController extends GetxController {
  final tickets = <int>[].obs;
  final isLoading = false.obs;
  final ServerService serverService = ServerService();

  @override
  void onInit() {
    super.onInit();
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    isLoading.value = true;

    try {
      final result = await serverService.getSupportTickets();
      tickets.assignAll(result);
    } catch (e) {
      print('❌ Ошибка в контроллере тикетов: $e');
    } finally {
      isLoading.value = false;
    }
  }
}