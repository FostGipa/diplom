import 'package:flutter/material.dart';
import 'circular_container.dart';

class TPrimaryHeaderContainer extends StatelessWidget {
  const TPrimaryHeaderContainer({
    super.key,
    required this.child,
    required this.backgroundColor,
    required this.circularColor,
  });

  final Widget child;
  final Color backgroundColor;
  final Color circularColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        color: backgroundColor,
        padding: const EdgeInsets.only(bottom: 0),
        child: Stack(
          children: [
            Positioned(
              top: -50,
              right: -80,
              child: TCircularContainer(backgroundColor: circularColor),
            ),
            Positioned(
              top: 30,
              right: -100,
              child: TCircularContainer(backgroundColor: circularColor),
            ),
            child,
          ],
        ),
      ),
    );
  }
}