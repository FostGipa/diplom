import 'package:app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/appbar/custom_notification_icon_widget.dart';

class THomeAppBar extends StatelessWidget {
  const THomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Доброе утро,', style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black
          )),
          SizedBox(height: TSizes.xs),
          Text('Кокоджамбик', style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black
          )),
        ],
      ),
      actions: [
        TNotificationsIcon(onPressed: () {}, iconColor: Colors.black)
      ],
    );
  }
}