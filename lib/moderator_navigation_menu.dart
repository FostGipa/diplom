import 'package:app/data/models/menu.dart';
import 'package:app/features/moderator/screens/moderator_home.dart';
import 'package:app/features/moderator/screens/moderator_tasks.dart';
import 'package:app/features/moderator/screens/moderator_tickets.dart';
import 'package:app/features/moderator/screens/moderator_users.dart';
import 'package:app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

const Color bottomNavBgColor = Color(0xFF17203A);

class ModeratorNavigationMenu extends StatefulWidget {
  const ModeratorNavigationMenu({super.key});

  @override
  State<ModeratorNavigationMenu> createState() => _ModeratorNavigationMenuState();
}

class _ModeratorNavigationMenuState extends State<ModeratorNavigationMenu> {
  int selectedNavIndex = 0;

  List<LottieNavItem> bottomNavItems = [
    LottieNavItem(asset: 'assets/lottie/home.json', label: 'Главная'),
    LottieNavItem(asset: 'assets/lottie/checklist.json', label: 'Заявки'),
    LottieNavItem(asset: 'assets/lottie/user.json', label: 'Пользователи'),
    LottieNavItem(asset: 'assets/lottie/chat.json', label: 'Чат'),
  ];

  final List<Widget> pages = [
    ModeratorHomeScreen(),
    ModeratorTasksScreen(),
    ModeratorUsersScreen(),
    ModeratorTicketsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: pages[selectedNavIndex],
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