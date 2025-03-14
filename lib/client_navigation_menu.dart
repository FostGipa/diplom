import 'package:app/features/client/home/screens/client_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:get/get.dart';

class ClientNavigationMenu extends StatelessWidget {
  const ClientNavigationMenu({super.key});

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

  final screens = [const ClientHomeScreen(), Container(color: Colors.orange), Container(color: Colors.orange)];

}
