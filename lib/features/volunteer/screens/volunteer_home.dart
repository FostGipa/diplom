import 'package:app/common/widgets/banners.dart';
import 'package:app/data/models/volunteer_model.dart';
import 'package:app/features/volunteer/controllers/volunteer_home_controller.dart';
import 'package:app/features/volunteer/screens/volunteer_task_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/appbar/custom_notification_icon_widget.dart';
import '../../../../common/widgets/custom_shaper/containers/primary_header_container.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../common/screens/archive_task.dart';
import '../../common/screens/notifications.dart';

class VolunteerHomeScreen extends StatefulWidget {
  const VolunteerHomeScreen({super.key});

  @override
  State<VolunteerHomeScreen> createState() => VolunteerHomeScreenState();
}

class VolunteerHomeScreenState extends State<VolunteerHomeScreen> {

  final VolunteerHomeController _controller = Get.put(VolunteerHomeController());

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
            if (_controller.volunteerData.value == null) {
              return const Text("Загрузка...");
            }
            Volunteer volunteer = _controller.volunteerData.value!;
            return Text(
              '${volunteer.name} ${volunteer.lastName}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
            );
          }),
        ],
      ),
      actions: [
        TNotificationsIcon(onPressed: () {
          Get.to(NotificationsScreen());
        }, text: "1"),
      ],
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
              .where((task) => task.taskStatus == "В процессе" || task.taskStatus == "Создана")
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
                      await Get.to(VolunteerTaskDetail(task: task));
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.taskName,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              task.taskEndDate!,
                              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                            ),
                          ],
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

