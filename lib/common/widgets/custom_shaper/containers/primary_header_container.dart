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
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(25),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(25),
          ),
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
      ),
    );
  }
}
