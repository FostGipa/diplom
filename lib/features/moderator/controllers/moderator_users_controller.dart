import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../data/models/client_model.dart';
import '../../../data/models/volunteer_model.dart';
import '../../../server/service.dart';

class ModeratorUsersController extends GetxController {
  final ServerService serverService = ServerService();
  final RxList<Client> clients = <Client>[].obs;
  final RxList<Volunteer> volunteers = <Volunteer>[].obs;
  final isLoading = true.obs;
  final expandedUserId = RxnInt();
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final searchFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      isLoading.value = true;
      final loadedClients = await serverService.getAllClients();
      final loadedVolunteers = await serverService.getAllVolunteers();

      // Обновляем списки пользователей
      clients.assignAll(loadedClients);
      volunteers.assignAll(loadedVolunteers);

      clients.refresh();
      volunteers.refresh();
    } catch (e) {
      Get.snackbar('Ошибка', 'Не удалось загрузить пользователей');
      print('Ошибка при загрузке пользователей: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> blockUser(int userId) async {
    try {
      await serverService.blockUser(userId);
      loadUsers();  // После блокировки перезагружаем данные
    } catch (e) {
      Get.snackbar('Ошибка', 'Не удалось заблокировать пользователя');
    }
  }

  Future<void> unblockUser(int userId) async {
    try {
      await serverService.unblockUser(userId);
      loadUsers();  // После разблокировки перезагружаем данные
    } catch (e) {
      Get.snackbar('Ошибка', 'Не удалось разблокировать пользователя');
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    launchUrlString("tel://+$phoneNumber");
  }
}