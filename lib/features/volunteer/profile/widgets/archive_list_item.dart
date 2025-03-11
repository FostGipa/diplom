import 'package:flutter/material.dart';

class ArchiveListItem extends StatelessWidget {

  final String taskName;
  final String taskDate;

  const ArchiveListItem({
    super.key,
    required this.taskName,
    required this.taskDate
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              taskName,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              taskDate,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        Text(
          'Выполнено',
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}