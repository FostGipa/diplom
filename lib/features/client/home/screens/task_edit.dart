import 'package:app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../../common/widgets/custom_date_time_picker.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../../../../utils/validators/validation.dart';
import '../controllers/task_edit_controller.dart';

class TaskEditScreen extends StatefulWidget {
  final int taskId;
  const TaskEditScreen({super.key, required this.taskId});

  @override
  State<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  late final TaskEditController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TaskEditController());
    controller.loadTaskData(widget.taskId);  // Load the task data when screen initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(Iconsax.arrow_left_2),
        ),
        title: Text(
          'Редактор заявки',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
        ),
      ),
      body: Obx(() {
        // Use `controller.isLoading` to show loading state
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.secondFormKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Информация о заявке', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
                  SizedBox(height: TSizes.spaceBtwSections),
                  CustomTextField(
                    prefixIcon: Iconsax.document,
                    controller: controller.taskName,
                    validator: (value) => TValidator.validateEmptyText('Название', value),                    label: 'Название',
                    onChanged: (value) => controller.validateForm(),                  ),
                  SizedBox(height: TSizes.spaceBtwInputFields),
                  TextField(
                    controller: controller.taskDescription,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Описание',
                      hintStyle: TextStyle(fontSize: 18),
                    ),
                    style: TextStyle(fontSize: 18),
                    maxLines: 5,
                    onChanged: (value) => controller.validateForm(),                  ),
                  SizedBox(height: TSizes.spaceBtwInputFields),
                  CustomTextField(
                    prefixIcon: Iconsax.profile_2user,
                    controller: controller.taskVolunteersCount,
                    validator: (value) => TValidator.validateEmptyText('Кол-во волонтеров', value),                    label: 'Кол-во требуемых волонтеров',
                    onChanged: (value) => controller.validateForm(),                  ),
                  SizedBox(height: TSizes.spaceBtwInputFields),
                  CustomTextField(
                    controller: controller.taskDurationController,
                    prefixIcon: Iconsax.timer,
                    validator: (value) => TValidator.validateEmptyText('Продолжительность', value),                    label: 'Продолжительность',
                    readOnly: true,
                    onTap: () async {
                      final initialTime = TimeOfDay.now();
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: initialTime,
                      );
                      if (pickedTime != null) {
                        String formattedTime = pickedTime.format(context);
                        controller.taskDurationController.text = formattedTime;
                        controller.validateForm();
                      }
                    },
                  ),
                  SizedBox(height: TSizes.spaceBtwInputFields),
                  TextField(
                    controller: controller.taskComment,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Комментарий',
                      hintStyle: TextStyle(fontSize: 18),
                    ),
                    style: TextStyle(fontSize: 18),
                    maxLines: 5,
                  ),
                  SizedBox(height: TSizes.spaceBtwInputFields),
                  CustomTextField(
                    controller: controller.taskAddress,
                    validator: (value) => TValidator.validateEmptyText('Адрес', value),
                    prefixIcon: Iconsax.location,
                    label: 'Адрес',
                  ),
                  SizedBox(height: TSizes.spaceBtwInputFields),
                  InkWell(
                    onTap: () async {
                      final result = await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                        builder: (context) => DateAndTimePicker(),
                      );

                      if (result != null && result['date'] != null && result['time'] != null) {
                        setState(() {
                          controller.selectedDate = result['date'];
                          controller.selectedTime = result['time'];

                          controller.taskStartDate.text = DateFormat('yyyy-MM-dd').format(controller.selectedDate!);
                          controller.taskStartTime.text = controller.selectedTime!.format(context);
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(14)),
                      child: Row(
                        children: [
                          Icon(Iconsax.calendar, color: Colors.grey),
                          SizedBox(width: TSizes.md),
                          Text(
                            controller.selectedDate != null && controller.selectedTime != null
                                ? '${DateFormat('EEEE, d MMMM', 'ru_RU').format(controller.selectedDate!)} , ${controller.selectedTime!.format(context)}'
                                : 'Выберите дату и время',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: TSizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.updateTask(widget.taskId);
                      },
                      child: Text("Сохранить изменения"),
                    // ),
                  )),
                  SizedBox(height: TSizes.spaceBtwSections)
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

