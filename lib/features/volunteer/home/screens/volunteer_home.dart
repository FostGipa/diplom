import 'package:app/data/models/volunteer_model.dart';
import 'package:app/features/volunteer/home/controllers/volunteer_home_controller.dart';
import 'package:app/features/volunteer/home/screens/volunteer_task_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/appbar/custom_notification_icon_widget.dart';
import '../../../../common/widgets/custom_shaper/containers/primary_header_container.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../../common/screens/notifications.dart';

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
    _controller.startAutoScroll();
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
                _banner(context, _controller.pageController, _controller.banners, _controller.currentIndex),
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

  Widget _banner(BuildContext context, PageController pageController, List<String> banners, int currentIndex) {
    return Center(
      child: SizedBox(
        height: 170,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: PageView.builder(
                controller: pageController,
                itemCount: banners.length,
                onPageChanged: (index) {
                  currentIndex = index;
                },
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Image.asset(banners[index]),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            SmoothPageIndicator(
              controller: pageController,
              count: banners.length,
              effect: WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: TColors.green,
                dotColor: Colors.grey.shade300,
              ),
            ),
          ],
        ),
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
          final activeTasks = _controller.activeTasks.where((task) => task.taskStatus == "Завершена").toList();
          return Column(
            children: activeTasks.map((task) {
              return Column(
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
                          color: _controller.getStatusColor(task.taskStatus),
                        ),
                      ),
                    ],
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
}

