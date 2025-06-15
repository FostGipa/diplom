import 'dart:async';
import 'package:app/data/models/client_model.dart';
import 'package:app/features/client/home/screens/task_create.dart';
import 'package:app/features/client/home/screens/task_detail.dart';
import 'package:app/features/common/screens/archive_task.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/banners.dart';
import '../../../../common/widgets/custom_shaper/containers/primary_header_container.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/device/device_utility.dart';
import '../controllers/client_home_controller.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => ClientHomeScreenState();
}

class ClientHomeScreenState extends State<ClientHomeScreen> with WidgetsBindingObserver{
  final ClientHomeController _controller = Get.put(ClientHomeController());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _controller.loadData();
    });
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
            padding: EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _appBar(context),
                SizedBox(height: TSizes.spaceBtwSections),
                BannerWidget(),
                SizedBox(height: TSizes.spaceBtwSections),
                _activeTasks(context),
                SizedBox(height: TSizes.spaceBtwSections),
                _archiveTasks(context),
                SizedBox(height: TSizes.spaceBtwItems),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async => {
                      await Get.to(ClientTaskCreateScreen()),
                      _controller.loadData()
                    },
                    child: const Text('Создать новую заявку'),
                  ),
                ),
                SizedBox(height: 80),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _appBar(BuildContext context) {
    return TAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Добрый день,',
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
    );
  }

  Widget _activeTasks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Активные заявки",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 24,
          ),
        ),
        SizedBox(height: TSizes.spaceBtwItems),
        Obx(() {
          final activeTasks = _controller.activeTasks
              .where((task) => task.taskStatus == "В процессе" || task.taskStatus == "Создана" || task.taskStatus == "Готова")
              .toList();

          if (activeTasks.isEmpty) {
            return const Text(
              "Нет активных заявок",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey),
            );
          }

          return Column(
            children: activeTasks.map((task) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await Get.to(TaskDetailScreen(task: task));
                      _controller.loadData();
                    },
                    child: SizedBox(
                      width: TDeviceUtils.getScreenWight(context),
                      child: TPrimaryHeaderContainer(
                        backgroundColor: TColors.green,
                        circularColor: Colors.white.withValues(alpha: 0.1),
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
                  SizedBox(height: TSizes.spaceBtwItems),
                ],
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _archiveTasks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Архив",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 24,
          ),
        ),
        SizedBox(height: TSizes.spaceBtwItems),
        Obx(() {
          final activeTasks = _controller.activeTasks
              .where((task) => task.taskStatus == "Завершена" || task.taskStatus == "Отменена")
              .toList();

          return Column(
            children: activeTasks.map((task) {
              return GestureDetector(
                onTap: () {
                  Get.to(() => ArchiveTask(task: task));
                },
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.taskName,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                              SizedBox(height: 4),
                              Text(
                                task.taskEndDate!,
                                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          task.taskStatus,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'VK Sans',
                            color: _controller.getStatusColor(task.taskStatus),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: TSizes.spaceBtwItems),
                  ],
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}
