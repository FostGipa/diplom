import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:app/features/volunteer/controllers/volunteer_task_detail_controller.dart';
import 'package:app/server/service.dart';

class DummyServerService extends ServerService {
  @override
  Future<bool> acceptRequest(int idTask, int idVolunteer) async => true;
}

void main() {
  late VolunteerTaskDetailController controller;
  setUp(() {
    controller = VolunteerTaskDetailController();
    Get.put(controller);
  });
  tearDown(Get.reset);
  test('Метод acceptTask выполняется без ошибок', () async {
    await controller.acceptTask(1, 10);
    expect(true, isTrue);
  });
}
