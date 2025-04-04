import 'package:app/data/models/client_model.dart';
import 'package:app/data/models/task_model.dart';
import 'package:app/utils/loaders/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/user_model.dart';
import '../../../../server/service.dart';
import '../../../../utils/formatters/formatter.dart';

class TaskCreateController extends GetxController {
  var addressSuggestions = <String>[].obs;
  final GlobalKey<FormState> secondFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> thirdFormKey = GlobalKey<FormState>();
  final ServerService serverService = ServerService();
  final FocusNode focusNode = FocusNode();
  final TFormatters formatters = TFormatters();
  final RxString phoneNumber = ''.obs;
  Rx<User?> userData = Rx<User?>(null);
  Rx<Client?> clientData = Rx<Client?>(null);

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController fullName = TextEditingController();
  final taskName = TextEditingController();
  final taskDescription = TextEditingController();
  final taskComment = TextEditingController();
  final taskVolunteersCount = TextEditingController();
  final taskStartDate = TextEditingController();
  final taskStartTime = TextEditingController();
  final taskAddress = TextEditingController();
  final taskDuration = TextEditingController();

  int currentStep = 0;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final PageController pageController = PageController();
  var selectedServices = [false, false, false, false, false, false, false, false].obs;
  final isFormValid = false.obs;
  final isFieldValid = <bool>[].obs;
  final List<Map<String, String>> services = [
    {"title": "Физическая помощь", "subtitle": "(уборка, переезд, мелкий ремонт)"},
    {"title": "Доставка и покупки", "subtitle": "(лекарства, продукты, вещи)"},
    {"title": "Сопровождение", "subtitle": "(в больницу, на мероприятие, прогулки)"},
    {"title": "Помощь с животными", "subtitle": "(выгул, временная передержка)"},
    {"title": "Социальная помощь", "subtitle": "(пообщаться, поддержка пожилых людей)"},
    {"title": "Юридическая поддержка", "subtitle": "(оформление документов, консультации)"},
    {"title": "Психологическая помощь", "subtitle": "(просто поговорить, советы)"},
    {"title": "Техническая помощь", "subtitle": "(починить телефон, компьютер)"}
  ];

  @override
  void onInit() {
    super.onInit();
    isFieldValid.assignAll(List.generate(4, (_) => false));
  }

  void validateField(int index, String? value) {
    isFieldValid[index] = value != null && value.isNotEmpty;
    updateFormValidity();
  }

  void updateDurationField(String value) {
    isFieldValid[3] = value.isNotEmpty;
    updateFormValidity();
    }

  void updateFormValidity() {
    isFormValid.value = isFieldValid.every((valid) => valid);
  }

  void toggleService(int index, bool value) {
    selectedServices[index] = value;
  }

  void nextPage() {
    if (currentStep < 2) {
      pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void previousPage() {
    if (currentStep > 0) {
      pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  Future<void> sendTask() async {
    final result = await serverService.getAddressCoordinates(taskAddress.text);

    List<String> selectedCategories = services
        .asMap()
        .entries
        .where((entry) => selectedServices[entry.key])
        .map((entry) => entry.value["title"]!)
        .toList();

    await serverService.createTask(TaskModel(
        taskName: taskName.text,
        taskDescription: taskDescription.text,
        taskComment: taskComment.text,
        taskCategories: selectedCategories,
        clientId: clientData.value?.idClient,
        volunteersId: [],
        taskDuration: taskDuration.text,
        taskVolunteersCount: int.parse(taskVolunteersCount.text),
        taskStartDate: taskStartDate.text,
        taskStartTime: taskStartTime.text,
        taskAddress: taskAddress.text,
        taskCoordinates: "${result?["coordinates"]["latitude"]},${result?["coordinates"]["longitude"]}",
        taskStatus: "Создана"
    ));
    Get.back();
    TLoaders.successSnackBar(title: "Успешно", message: "Заявка успешно создана");
  }


  Future<void> loadUserData() async {
    userData.value = serverService.getCachedUser();
    clientData.value = await serverService.getClient(userData.value!.idUser!);
    phoneController.text = formatters.phoneMask.maskText(userData.value!.phoneNumber);
    fullName.text = "${clientData.value!.lastName} ${clientData.value!.name} ${clientData.value!.middleName!}";
  }

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
