import 'package:app/data/models/volunteer_model.dart';
import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../server/service.dart';

class ProfileController extends GetxController {
  final ServerService serverService = ServerService();
  var isLoading = true.obs;
  Rx<Volunteer?> volunteerData = Rx<Volunteer?>(null);
  Rx<User?> userData = Rx<User?>(null);

  void getUser() {
    userData.value = serverService.getCachedUser();
  }

  Future<void> fetchVolunteerData(int userId) async {
    try {
      volunteerData.value = await serverService.getVolunteer(userId);
    } catch (e) {
      print("Ошибка при получении данных клиента: $e");
    }
  }

  Future<void> loadData() async {
    isLoading.value = true;
    getUser();
    if (userData.value != null) {
      await fetchVolunteerData(userData.value!.idUser!);
    }
    isLoading.value = false;
    update();
  }
}