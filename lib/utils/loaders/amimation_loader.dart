import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../constants/sizes.dart';

class TAnimationWidget extends StatelessWidget {
  const TAnimationWidget({
    super.key,
    required this.text,
    required this.animation,
    this.showAction = false,
    this.actionText,
    this.onActionPressed,

  });

  final String text;
  final String animation;
  final bool showAction;
  final String? actionText;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(animation, width: MediaQuery.of(context).size.width * 0.5, animate: true),
          const SizedBox(height: TSizes.defaultSpace),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: TSizes.defaultSpace),
          showAction
              ? SizedBox(
                  width: 250,
                  child: OutlinedButton(
                      onPressed: onActionPressed,
                      style: OutlinedButton.styleFrom(backgroundColor: Colors.black26),
                      child: Text(
                        actionText!,
                        style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.red),
                      )),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
