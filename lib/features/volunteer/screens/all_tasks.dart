import 'package:app/features/volunteer/screens/volunteer_task_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../../common/widgets/custom_shaper/containers/primary_header_container.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../controllers/all_tasks_controller.dart';

class AllTasksScreen extends StatefulWidget {
  const AllTasksScreen({super.key});

  @override
  State<AllTasksScreen> createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
  final AllTasksController _controller = Get.put(AllTasksController());
  String? _selectedCategory;
  int? _minAge;
  int? _maxAge;

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
      final activeTasks = _controller.allTasks.where((task) {
        final age = _calculateAge(task.client!.dateOfBirth);
        final matchesAge = (_minAge == null || age >= _minAge!) &&
            (_maxAge == null || age <= _maxAge!);

        return task.taskStatus == "Создана" &&
            (_selectedCategory == null || task.taskCategories.contains(_selectedCategory)) &&
            (task.taskName.toLowerCase().contains(_controller.searchQuery.toLowerCase()) ||
                task.taskDescription.toLowerCase().contains(_controller.searchQuery.toLowerCase())) &&
            matchesAge;
      }).toList();

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
    String? tempCategory = _selectedCategory;
    int? tempMinAge = _minAge;
    int? tempMaxAge = _maxAge;

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
                      ].map((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: TSizes.spaceBtwItems * 2),
                    Text("Возраст клиента", style: TextStyle(fontSize: 20)),
                    SizedBox(height: TSizes.spaceBtwItems),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'От',
                            keyboardType: TextInputType.number,
                            initialValue: tempMinAge?.toString(),
                            onChanged: (value) {
                              setDialogState(() {
                                tempMinAge = int.tryParse(value);
                              });
                            },
                          ),
                        ),
                        SizedBox(width: TSizes.spaceBtwItems),
                        Expanded(
                          child: CustomTextField(
                            label: 'До',
                            keyboardType: TextInputType.number,
                            initialValue: tempMaxAge?.toString(),
                            onChanged: (value) {
                              setDialogState(() {
                                tempMaxAge = int.tryParse(value);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategory = null;
                      _minAge = null;
                      _maxAge = null;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text("Сбросить"),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategory = tempCategory;
                      _minAge = tempMinAge;
                      _maxAge = tempMaxAge;
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

  int _calculateAge(String birthDateString) {
    try {
      final DateFormat dateFormat = DateFormat("yyyy-MM-dd");
      final birthDate = dateFormat.parse(birthDateString);
      final today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      print("Ошибка при парсинге даты: $e");
      return 0;
    }
  }
}