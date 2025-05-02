import 'package:app/data/models/menu.dart';
import 'package:app/features/client/home/screens/client_home.dart';
import 'package:app/features/client/home/screens/client_profile.dart';
import 'package:app/features/common/screens/qr_scanner.dart';
import 'package:app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

const Color bottomNavBgColor = Color(0xFF17203A);

class ClientNavigationMenu extends StatefulWidget {
  const ClientNavigationMenu({super.key});

  @override
  State<ClientNavigationMenu> createState() => _ClientNavigationMenuState();
}

class _ClientNavigationMenuState extends State<ClientNavigationMenu> {
  int selectedNavIndex = 0;

  List<LottieNavItem> bottomNavItems = [
    LottieNavItem(asset: 'assets/lottie/home.json', label: 'Главная'),
    LottieNavItem(asset: 'assets/lottie/qrcode.json', label: 'QR-код'),
    LottieNavItem(asset: 'assets/lottie/user.json', label: 'Профиль'),
  ];

  final List<Widget> pages = [
    ClientHomeScreen(),
    QRScanScreen(),
    ClientProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: pages[selectedNavIndex],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        decoration: BoxDecoration(
          color: bottomNavBgColor.withAlpha((0.8 * 255).toInt()),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: bottomNavBgColor.withAlpha((0.3 * 255).toInt()),
              offset: const Offset(0, 20),
              blurRadius: 20,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(bottomNavItems.length, (index) {
              final item = bottomNavItems[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedNavIndex = index;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBar(isActive: selectedNavIndex == index),
                    SizedBox(
                      height: 36,
                      width: 36,
                      child: Lottie.asset(
                        item.asset,
                        repeat: selectedNavIndex == index,
                        animate: selectedNavIndex == index,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class AnimatedBar extends StatelessWidget {
  const AnimatedBar({
    super.key, required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(bottom: 2),
      height: 4,
      width: isActive ? 20 : 0,
      decoration: BoxDecoration(
          color: TColors.green,
          borderRadius: BorderRadius.all(Radius.circular(12))
      ),
    );
  }
}