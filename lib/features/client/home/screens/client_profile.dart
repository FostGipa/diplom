import 'package:app/features/authentication/screens/login.dart';
import 'package:app/features/client/home/controllers/client_profile_controller.dart';
import 'package:app/features/common/screens/about_app.dart';
import 'package:app/features/common/screens/notifications.dart';
import 'package:app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/custom_user_avatar.dart';
import '../../../../common/widgets/profile_menu_widget.dart';

class ClientProfileScreen extends StatefulWidget {
  const ClientProfileScreen({super.key});

  @override
  State<ClientProfileScreen> createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  final ClientProfileController _controller = Get.put(ClientProfileController());

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
                    firstName: _controller.clientData.value!.name,
                    lastName: _controller.clientData.value!.lastName,
                  ),
                  SizedBox(height: TSizes.spaceBtwItems),
                  Text('${_controller.clientData.value?.lastName} ${_controller.clientData.value?.name}', style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                  )),
                  SizedBox(height: TSizes.spaceBtwSections),
                  ProfileMenuWidget(
                      title: 'Уведомления',
                      icon: Iconsax.notification,
                      onPress: () {
                        Get.to(NotificationsScreen());
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
                ],
              ),
            ),
          )
      );
    });
  }
}