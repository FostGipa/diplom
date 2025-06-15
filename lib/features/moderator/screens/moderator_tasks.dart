import 'package:app/features/common/screens/archive_task.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../data/models/task_model.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/moderator_tasks_controller.dart';

class ModeratorTasksScreen extends StatefulWidget {
  const ModeratorTasksScreen({super.key});

  @override
  State<ModeratorTasksScreen> createState() => _ModeratorTasksScreenState();
}

class _ModeratorTasksScreenState extends State<ModeratorTasksScreen> {

  final ModeratorTasksController _controller = Get.put(ModeratorTasksController());
  String? _selectedCategory;
  String? _selectedCity;
  String? _selectedStatus;

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Заявки",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Iconsax.filter),
                      onPressed: () => _showFilterDialog(),
                    ),
                  ],
                ),
                SizedBox(height: TSizes.spaceBtwItems),
                SearchBar(
                  backgroundColor: WidgetStateProperty.all(Colors.grey.shade300),
                  controller: _controller.searchController,
                  focusNode: _controller.searchFocusNode,
                  hintText: 'Поиск заявок...',
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  elevation: WidgetStateProperty.all(1),
                  leading: const Icon(Icons.search),
                  onChanged: (value) => _controller.searchQuery.value = value,
                  trailing: [
                    if (_controller.searchQuery.value.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _controller.searchController.clear();
                          _controller.searchQuery.value = '';
                          _controller.searchFocusNode.unfocus();
                        },
                      ),
                  ],
                ),
                SizedBox(height: TSizes.spaceBtwSections),
                _tasks(context),
                SizedBox(height: 80),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _tasks(BuildContext context) {
    return Obx(() {
      final activeTasks = _controller.totalTasks.where((task) {
        final matchesCategory = _selectedCategory == null ||
            task.taskCategories.contains(_selectedCategory);

        final matchesSearch = task.taskName.toLowerCase().contains(_controller.searchQuery.toLowerCase()) ||
            task.taskDescription.toLowerCase().contains(_controller.searchQuery.toLowerCase());

        final matchesCity = _selectedCity == null ||
            task.taskAddress.toLowerCase().contains('г ${_selectedCity!.toLowerCase()}');

        final matchesStatus = _selectedStatus == null ||
            task.taskStatus.toLowerCase() == _selectedStatus!.toLowerCase();

        return matchesCategory && matchesSearch && matchesCity && matchesStatus;
      }).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (activeTasks.isEmpty)
            const Text(
              "Нет заявок",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey),
            )
          else
            ...activeTasks.map((task) => TaskCard(task: task))
        ],
      );
    });
  }

  void _showFilterDialog() {
    String? tempCategory = _selectedCategory;
    String? tempCity = _selectedCity;
    String? tempStatus = _selectedStatus; // Новый временный статус

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: Text("Фильтры", style: TextStyle(fontSize: 24)),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Категория", style: TextStyle(fontSize: 20)),
                    SizedBox(height: TSizes.spaceBtwInputFields),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: tempCategory,
                      hint: Text("Выберите категорию"),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onChanged: (String? newValue) {
                        setDialogState(() {
                          tempCategory = newValue;
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
                      ].map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: TSizes.spaceBtwItems * 2),

                    /// 🟦 Новый фильтр по статусу
                    Text("Статус заявки", style: TextStyle(fontSize: 20)),
                    SizedBox(height: TSizes.spaceBtwItems),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: tempStatus,
                      hint: Text("Выберите статус"),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onChanged: (String? newValue) {
                        setDialogState(() {
                          tempStatus = newValue;
                        });
                      },
                      items: [
                        "Создана",
                        "Готова",
                        "В процессе",
                        "Завершена",
                        "Отменена"
                      ].map((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                    ),

                    SizedBox(height: TSizes.spaceBtwItems * 2),
                    Text("Город", style: TextStyle(fontSize: 20)),
                    SizedBox(height: TSizes.spaceBtwItems),
                    CustomTextField(
                      label: 'Введите город',
                      initialValue: tempCity,
                      onChanged: (value) {
                        setDialogState(() {
                          tempCity = value.trim();
                        });
                      },
                    ),
                    SizedBox(height: TSizes.spaceBtwItems * 2),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategory = null;
                      _selectedCity = null;
                      _selectedStatus = null; // Сбросить статус
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text("Сбросить"),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategory = tempCategory;
                      _selectedCity = tempCity;
                      _selectedStatus = tempStatus; // Применить статус
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text("Применить"),
                ),
              ],
            );
          },
        );
      },
    );
  }

}

class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    DateTime startDate = DateFormat('yyyy-MM-dd').parse(task.taskStartDate);
    String formattedDate = DateFormat('dd MMM yyyy').format(startDate);
    String formattedTime = task.taskStartTime;

    return GestureDetector(
      onTap: () {
        Get.to(ArchiveTask(task: task));
      },
      child: Container( // 👈 Обёртка для ширины
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Заявка №${task.taskNumber}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Статус: ${task.taskStatus}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: task.taskStatus == 'Создана' || task.taskStatus == 'В процессе'
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Дата: $formattedDate',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  'Время: $formattedTime',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
}
