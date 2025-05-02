import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String firstName;
  final String lastName;

  const ProfileAvatar({
    super.key,
    required this.firstName,
    required this.lastName,
  });

  @override
  Widget build(BuildContext context) {
    String initials = '';
    if (lastName.isNotEmpty) initials += lastName[0].toUpperCase();
    if (firstName.isNotEmpty) initials += firstName[0].toUpperCase();

    return CircleAvatar(
      radius: 50, // размер круга
      backgroundColor: Colors.grey.shade400, // серый цвет фона
      child: Text(
        initials,
        style: TextStyle(
          fontFamily: 'VK Sans',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}