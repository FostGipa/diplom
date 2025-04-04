import 'package:app/features/volunteer/home/screens/volunteer_task_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../common/widgets/custom_shaper/containers/primary_header_container.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../../client/home/screens/task_detail.dart';
import '../controllers/all_tasks_controller.dart';

class AllTasksScreen extends StatefulWidget {
  const AllTasksScreen({super.key});

  @override
  State<AllTasksScreen> createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
  final AllTasksController _controller = Get.put(AllTasksController());
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _controller.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: TSizes.defaultSpace, vertical: TSizes.appBarHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _priorityTasks(context),
                SizedBox(height: TSizes.spaceBtwSections),
                _activeTasks(context),

              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _activeTasks(BuildContext context) {
    return Obx(() {
      final activeTasks = _controller.allTasks
          .where((task) => task.taskStatus == "Создана")
          .toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Доступные заявки",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: 24,
            ),
          ),
          SizedBox(height: TSizes.spaceBtwItems),
          if (activeTasks.isEmpty)
            const Text(
              "Нет активных заявок",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey),
            )
          else
            ...activeTasks.map((task) => _taskCard(context, task)),
        ],
      );
    });
  }

  Widget _priorityTasks(BuildContext context) {
    return Obx(() {
      final now = DateTime.now();
      final priorityTasks = _controller.allTasks.where((task) {
        final startDate = DateFormat("yyyy-MM-dd").parse(task.taskStartDate);
        final daysLeft = startDate.difference(now).inDays;
        return daysLeft <= 1 && task.taskStatus == "Создана";
      }).toList();

      if (priorityTasks.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Приоритетные заявки",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.red,
              fontSize: 24,
            ),
          ),
          SizedBox(height: TSizes.spaceBtwItems),
          ...priorityTasks.map((task) => _taskCard(context, task)),
        ],
      );
    });
  }

  Widget _taskCard(BuildContext context, dynamic task) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            await Get.to(() => VolunteerTaskDetail(task: task));
            _controller.loadData();
          },
          child: SizedBox(
            width: TDeviceUtils.getScreenWight(context),
            child: TPrimaryHeaderContainer(
              backgroundColor: Colors.white,
              circularColor: TColors.green.withOpacity(0.2),
              child: Padding(
                padding: EdgeInsets.all(TSizes.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.taskName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: TSizes.sm),
                    Text(
                      task.taskDescription,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      softWrap: true,
                    ),
                    SizedBox(height: TSizes.spaceBtwInputFields),
                    Row(
                      children: [
                        const Icon(Iconsax.calendar_1, color: Colors.black),
                        SizedBox(width: TSizes.sm),
                        Text(
                          task.taskStartDate,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: TSizes.spaceBtwItems),
      ],
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Фильтры", style: TextStyle(fontSize: 24)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Категория", style: TextStyle(fontSize: 20)),
              SizedBox(height: TSizes.spaceBtwInputFields),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _selectedCategory,
                hint: Text("Выберите категории"),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                items: [
                  "Физическая помощь",
                  "Доставка и покупки",
                  "Сопровождение",
                  "Помощь с животными",
                  "Социальная помощь",
                  "Юридическая поддержка",
                  "Психологическая помощь",
                  "Техническая помощь"
                ].map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Отмена"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {});
              },
              child: Text("Применить"),
            ),
          ],
        );
      },
    );
  }
}