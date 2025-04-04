import 'package:app/features/volunteer/home/screens/all_tasks.dart';
import 'package:app/features/volunteer/home/screens/volunteer_home.dart';
import 'package:app/features/volunteer/profile/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:get/get.dart';

class VolunteerNavigationMenu extends StatelessWidget {
  const VolunteerNavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: Obx(
          () => NavigationBar(
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) => controller.selectedIndex.value = index,
            backgroundColor: Colors.white,
            indicatorColor: Colors.black.withOpacity(0.1),
            
            destinations: const [
              NavigationDestination(icon: SvgIcon(icon: SvgIconData('assets/icons/home.svg')), label: 'Главная'),
              NavigationDestination(icon: SvgIcon(icon: SvgIconData('assets/icons/qrcode.svg')), label: 'QR-код'),
              NavigationDestination(icon: SvgIcon(icon: SvgIconData('assets/icons/profile.svg')), label: 'Профиль'),
              ],
          ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [const VolunteerHomeScreen(), const AllTasksScreen(), const ProfileScreen()];

}
