import 'package:app/common/widgets/bar_chart.dart';
import 'package:app/features/moderator/controllers/moderator_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../utils/constants/sizes.dart';

class ModeratorHomeScreen extends StatefulWidget {
  const ModeratorHomeScreen({super.key});

  @override
  State<ModeratorHomeScreen> createState() => _ModeratorHomeScreenState();
}

class _ModeratorHomeScreenState extends State<ModeratorHomeScreen> {

  final ModeratorHomeController _controller = Get.put(ModeratorHomeController());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _controller.getAllTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Статистика",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 4,
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Общая статистика',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Iconsax.calendar_1),
                    onPressed: () => _showDateRangePicker(),
                  ),
                ],
              ),
              SizedBox(height: TSizes.spaceBtwItems),
              Obx(() => Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  StatCard(title: 'Всего заявок', value: '${_controller.totalTasks.value}'),
                  StatCard(title: 'Новые за период', value: '${_controller.newTasksInPeriod.value}'),
                  StatCard(title: 'Отклонённые заявки', value: '${_controller.rejectedTasks.value}'),
                ],
              )),
              SizedBox(height: TSizes.spaceBtwSections),
              BarChartSample1(),
              SizedBox(height: TSizes.spaceBtwSections),
              const Text(
                'Пользователи',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: TSizes.spaceBtwItems),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: const [
                  StatCard(title: 'Активные волонтёры', value: '102'),
                  StatCard(title: 'Новые клиенты', value: '28'),
                  StatCard(title: 'Новые волонтёры', value: '17'),
                ],
              ),
              SizedBox(height: 80)
            ],
          ),
        );
      })
    );
  }

  Future<void> _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _controller.selectedDateRange,
    );

    if (picked != null) {
      await _controller.updateDateRange(picked);
    }
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;

  const StatCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: TSizes.spaceBtwItems),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
