import 'package:flutter/material.dart';

import '../../../../../utils/constants/sizes.dart';

class TLoginHeader extends StatelessWidget {
  const TLoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Image(
            height: 100,
            image: AssetImage("assets/images/logo.png")),
        const SizedBox(height: TSizes.md),
        Text('С возвращением!', style: Theme
            .of(context)
            .textTheme
            .headlineMedium,),

        const SizedBox(height: TSizes.sm),

        Text('Вместе мы можем сделать мир лучше!', style: Theme
            .of(context)
            .textTheme
            .bodyMedium,),
      ],
    );
  }
}