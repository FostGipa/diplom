import 'package:app/common/widgets/appbar/appbar.dart';
import 'package:flutter/material.dart';
import '../../../../common/widgets/custom_shaper/containers/primary_header_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  TAppBar()
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}

