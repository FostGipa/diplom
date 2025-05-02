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
    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Выберите дату и время',
            style: TextStyle(fontFamily: 'VK Sans', fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          // Выбор даты
          _buildDateSelector(),
          const SizedBox(height: TSizes.spaceBtwSections),

          // Выбор времени
          _buildTimeSelector(),
          const SizedBox(height: TSizes.spaceBtwSections),

          // Кнопка подтверждения
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _canSubmit() ? _submitSelection : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: TSizes.md),
                backgroundColor: TColors.green,
              ),
              child: const Text('Подтвердить выбор'),
            ),
          ),
          SizedBox(height: TSizes.spaceBtwItems)
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Дата выполнения',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        InkWell(
          onTap: _selectDate,
          borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: TSizes.md,
              horizontal: TSizes.defaultSpace,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
            ),
            child: Row(
              children: [
                const Icon(Iconsax.calendar_1, color: TColors.black),
                const SizedBox(width: TSizes.spaceBtwItems),
                Text(
                  selectedDate != null
                      ? DateFormat('EEEE, d MMMM', 'ru_RU').format(selectedDate!)
                      : 'Нажмите для выбора даты',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Время выполнения',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        InkWell(
          onTap: _selectTime,
          borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: TSizes.md,
              horizontal: TSizes.defaultSpace,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
            ),
            child: Row(
              children: [
                const Icon(Iconsax.clock, color: TColors.black),
                const SizedBox(width: TSizes.spaceBtwItems),
                Text(
                  selectedTime != null
                      ? selectedTime!.format(context)
                      : 'Нажмите для выбора времени',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('ru', 'RU'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: TColors.green,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: TColors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: TColors.green,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: TColors.black,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteTextColor: TColors.black,
              dayPeriodTextColor: TColors.black,
              hourMinuteColor: Colors.grey.shade200,
              dayPeriodColor: Colors.grey.shade200,
              dialHandColor: TColors.green,
              dialBackgroundColor: Colors.grey.shade100,
              hourMinuteTextStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  bool _canSubmit() {
    return selectedDate != null && selectedTime != null;
  }

  void _submitSelection() {
    if (_canSubmit()) {
      Navigator.pop(context, {
        'date': selectedDate,
        'time': selectedTime,
      });
    }
  }
}