import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';

class DateAndTimePicker extends StatefulWidget {
  const DateAndTimePicker({super.key});

  @override
  DateAndTimePickerState createState() => DateAndTimePickerState();
}

class DateAndTimePickerState extends State<DateAndTimePicker> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    final times = ['10:00', '13:00', '14:00', '15:00', '16:00', '18:00', '19:00'];
    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Дата и время',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: TSizes.spaceBtwItems),
          InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365)),
                locale: Locale('ru', 'RU'), // Указываем локализацию на русском языке
              );
              if (picked != null && picked != selectedDate) {
                setState(() {
                  selectedDate = picked;
                });
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Iconsax.calendar, color: Colors.grey),
                  SizedBox(width: TSizes.md),
                  Text(
                    selectedDate != null
                        ? DateFormat('EEEE, d MMMM', 'ru_RU').format(selectedDate!)
                        : 'Выберите дату',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: times.map((time) {
              return SizedBox(
                width: 80,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      selectedTime = TimeOfDay(
                          hour: int.parse(time.split(':')[0]),
                          minute: int.parse(time.split(':')[1]));
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: selectedTime != null && selectedTime!.format(context) == time
                        ? TColors.green
                        : Color(0xFFF5F5F9),
                    foregroundColor: selectedTime != null && selectedTime!.format(context) == time
                        ? Colors.white
                        : Colors.black,
                  ),
                  child: Text(
                    time,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Return selected date and time to the parent screen
              Navigator.pop(context, {
                'date': selectedDate,
                'time': selectedTime,
              });
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 48),
              backgroundColor: Colors.green,
            ),
            child: Text('Подтвердить'),
          ),
        ],
      ),
    );
  }
}