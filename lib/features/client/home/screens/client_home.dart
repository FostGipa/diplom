import 'package:app/data/models/client_model.dart';
import 'package:app/features/client/home/screens/task_create.dart';
import 'package:app/features/client/home/screens/task_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/custom_shaper/containers/primary_header_container.dart';
import '../../../../data/task_model.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/appbar/custom_notification_icon_widget.dart';
import '../../../../utils/device/device_utility.dart';
import '../controllers/client_home_controller.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => ClientHomeScreenState();
}

class ClientHomeScreenState extends State<ClientHomeScreen> {
  final ClientHomeController _controller = Get.put(ClientHomeController());

  @override
  void initState() {
    super.initState();
    _controller.fetchClientData(1); // Пример ID пользователя
    _controller.fetchClientTasks(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TAppBar(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Доброе утро,',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black),
                    ),
                    const SizedBox(height: TSizes.xs),
                    Obx(() {
                      if (_controller.clientData.value == null) {
                        return const Text("Загрузка...");
                      }
                      Client client = _controller.clientData.value!;
                      return Text(
                        '${client.name} ${client.lastName}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
                      );
                    }),
                  ],
                ),
                actions: [
                  TNotificationsIcon(onPressed: () {}, iconColor: Colors.black),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              const Text(
                "Активные заявки",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              // Список активных заявок
              Obx(() {
                if (_controller.activeTasks.isEmpty) {
                  return const Text(
                    "Нет активных заявок",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey),
                  );
                }
                return Column(
                  children: _controller.activeTasks.map((task) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(TaskDetailScreen(task: task));
                          },
                          child: SizedBox(
                            width: TDeviceUtils.getScreenWight(context),
                            child: TPrimaryHeaderContainer(
                              backgroundColor: TColors.green,
                              circularColor: Colors.white.withOpacity(0.1),
                              child: Padding(
                                padding: EdgeInsets.all(TSizes.lg),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.taskName,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: TSizes.sm),
                                    Text(
                                      task.taskDescription,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                      softWrap: true,
                                    ),
                                    SizedBox(height: TSizes.spaceBtwInputFields),
                                    Row(
                                      children: [
                                        Icon(Iconsax.calendar_1, color: Colors.white),
                                        SizedBox(width: TSizes.sm),
                                        Text(
                                          task.taskStartDate,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
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
                        SizedBox(height: TSizes.spaceBtwItems), // Добавляем отступ между заявками
                      ],
                    );
                  }).toList(),
                );
              }),

              const SizedBox(height: TSizes.spaceBtwSections),
              const Text(
                "Архив",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const ClientTaskCreateScreen()),
                  child: const Text('Создать новую заявку'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTaskDetails(BuildContext context, TaskModel task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.taskName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                task.taskDescription,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Информация',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Iconsax.calendar_1, color: Colors.black),
                  const SizedBox(width: 8),
                  Text(
                    task.taskStartDate,
                    style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Iconsax.map, color: Colors.black),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      task.taskAddress,
                      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Iconsax.user, color: Colors.black),
                  const SizedBox(width: 8),
                  // Text(
                  //   task.taskClient.name,
                  //   style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                  // ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
            ],
          ),
        );
      },
    );
  }
}
