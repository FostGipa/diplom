import 'package:app/features/moderator/controllers/moderator_volunteer_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/custom_user_avatar.dart';
import '../../../utils/constants/sizes.dart';

class ModeratorVolunteerProfile extends StatefulWidget {
  final int userId;
  const ModeratorVolunteerProfile({super.key, required this.userId});

  @override
  State<ModeratorVolunteerProfile> createState() => _ModeratorVolunteerProfileState();
}

class _ModeratorVolunteerProfileState extends State<ModeratorVolunteerProfile> {

  final ModeratorVolunteerProfileController _controller = Get.put(ModeratorVolunteerProfileController());

  @override
  void initState() {
    super.initState();
    _controller.loadData(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Профиль', style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
            )),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildData(context),
                  SizedBox(height: TSizes.spaceBtwSections),
                  _archiveTasks(context),
                  SizedBox(height: 80),
                ],
              )
            ),
          )
      );
    });
  }

  Column buildData(BuildContext context) {
    return Column(
      children: [
        ProfileAvatar(
          firstName: _controller.volunteerData.value!.name,
          lastName: _controller.volunteerData.value!.lastName,
        ),
        SizedBox(height: TSizes.spaceBtwItems),
        Text('${_controller.volunteerData.value?.lastName} ${_controller.volunteerData.value?.name}', style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 25,
        )),
        Text('Добро ID: ${_controller.volunteerData.value?.dobroId}', style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 18
        )),
        SizedBox(height: TSizes.spaceBtwSections),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text('${_controller.volunteerData.value?.completedTasks}', style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24
                  )),
                  Text('Добрые дела', style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18
                  ))
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text('${_controller.volunteerData.value?.helpHours}ч.', style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24
                  )),
                  Text('Часы', style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18
                  ))
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text('${_controller.volunteerData.value?.rating}', style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24
                  )),
                  Text('Рейтинг', style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18
                  ))
                ],
              ),
            ),
          ],
        ),
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
