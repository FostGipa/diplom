import 'package:app/features/authentication/screens/login.dart';
import 'package:app/features/common/screens/about_app.dart';
import 'package:app/features/volunteer/controllers/profile_controller.dart';
import 'package:app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../common/widgets/custom_user_avatar.dart';
import '../../../common/widgets/profile_menu_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _controller = Get.put(ProfileController());

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
                  SizedBox(height: TSizes.spaceBtwSections),
                  ProfileMenuWidget(
                      title: 'Моя ЛВК',
                      icon: Iconsax.card,
                      onPress: () {
                        Get.dialog(AlertDialog(
                          title: Text("Ваша личная волонтерская книжка", textAlign: TextAlign.center,),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: QrImageView(
                                    data: 'https://dobro.ru/volunteers/${_controller.volunteerData.value?.dobroId}/resume',
                                    version: QrVersions.auto,
                                    size: 200.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: Text("Закрыть"),
                            ),
                          ],
                        ));
                      }),
                  ProfileMenuWidget(
                      title: 'О приложении',
                      icon: Iconsax.warning_2,
                      onPress: () {
                        Get.to(AboutAppScreen());
                      }),
                  ProfileMenuWidget(
                      title: 'Выйти из аккаунта',
                      icon: Iconsax.logout,
                      onPress: () {
                        final box = GetStorage();
                        box.remove("cached_user");
                        Get.offAll(LoginScreen());
                      },
                      textColor: Colors.red,
                      endIcon: false),
                  SizedBox(height: 80),
                ],
              ),
            ),
          )
      );
    });
  }
}