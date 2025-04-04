import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../utils/constants/colors.dart';

class TNotificationsIcon extends StatelessWidget {
  const TNotificationsIcon({
    super.key,
    required this.onPressed,
    required this.text,
  });

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(Iconsax.notification, color: Colors.black),
        ),
        if (text != "0") // Проверяем, если text не "0", показываем индикатор
          Positioned(
            right: 0,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: TColors.failed,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Text(
                  text,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .apply(color: Colors.white, fontSizeFactor: 0.8),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
