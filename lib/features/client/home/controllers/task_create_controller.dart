import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../server/service.dart';

class TaskCreateController extends GetxController {
  var addressSuggestions = <String>[].obs;
  final ServerService serverService = ServerService();
  final addressController = TextEditingController();

  // Метод для получения подсказок адресов
  void fetchAddressSuggestions(String query) async {
    if (query.isEmpty) {
      addressSuggestions.clear();
      return;
    }

    final fetchedSuggestions = await serverService.fetchAddressSuggestions(query);
    if (fetchedSuggestions != null) {
      addressSuggestions.value = fetchedSuggestions;
    }
  }
}
