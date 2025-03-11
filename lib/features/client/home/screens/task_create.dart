import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl/intl.dart';
import '../../../../common/styles/spacing_styles.dart';
import '../../../../common/widgets/custom_date_time_picker.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/validators/validation.dart';
import '../controllers/task_create_controller.dart';

class ClientTaskCreateScreen extends StatefulWidget {
  const ClientTaskCreateScreen({super.key});

  @override
  State<ClientTaskCreateScreen> createState() => ClientTaskCreateScreenState();
}

class ClientTaskCreateScreenState extends State<ClientTaskCreateScreen> {
  int currentStep = 0;
  bool isOtherSelected = false;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final TaskCreateController controller = Get.put(TaskCreateController());

  @override
  Widget build(BuildContext context) {
    final List<Widget> steps = [
      firstStep(context),
      secondStep(context),
      thirdStep(context)
    ];
    return Scaffold(
      body: Padding(
        padding: TSpacingStyle.paddingWithAppBarHeight,
        child: Column(
          children: [
            /// Статичная верхняя часть
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Iconsax.arrow_left),
                  onPressed: currentStep > 0
                      ? () => setState(() => currentStep--)
                      : null,
                ),
                TextButton(
                  onPressed: currentStep < steps.length - 1
                      ? () => setState(() => currentStep++)
                      : null,
                  child: Text('Далее', style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                  )),
                ),
              ],
            ),
            SizedBox(height: TSizes.spaceBtwItems),
            LinearProgressIndicator(
              value: (currentStep) / steps.length,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            SizedBox(height: TSizes.spaceBtwItems),

            /// Динамическая нижняя часть
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: TSizes.spaceBtwSections),
                child: steps[currentStep],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Первый шаг заявки
  Widget firstStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Выберите услуги',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: TSizes.spaceBtwItems),
        Text('Выберите одну или несколько необходимых услуг', style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: TColors.textGrey
        )),
        SizedBox(height: TSizes.spaceBtwSections),
        CheckboxListTile(
          title: Text('Уборка квартиры', style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20
          )),
          value: false,
          onChanged: (value) {},
        ),
        CheckboxListTile(
          title: Text('Помощь в огороде', style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20
          )),
          value: false,
          onChanged: (value) {},
        ),
        CheckboxListTile(
          title: Text('Доставка', style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20
          )),
          value: false,
          onChanged: (value) {},
        ),
        CheckboxListTile(
          title: Text('Сопровождение', style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20
          )),
          value: false,
          onChanged: (value) {},
        ),
        CheckboxListTile(
          title: Text('Другое', style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20
          )),
          value: isOtherSelected,
          onChanged: (value) {
            setState(() {
              isOtherSelected = value ?? false;
            });
          },
        ),
        SizedBox(height: TSizes.spaceBtwItems),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SizeTransition(
                sizeFactor: animation,
                axisAlignment: 1.0,
                child: child,
              ),
            );
          },
          child: isOtherSelected
              ? TextField(
            key: ValueKey('otherTextField'),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Опишите услугу',
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18
                )
            ),
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18
            ),
            maxLines: 3,
          )
              : SizedBox.shrink(),
        ),
      ],
    );
  }

  /// Второй шаг заявки
  Widget secondStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Описание',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: TSizes.spaceBtwItems),
        Text('Подробно распишите, что требуется сделать', style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: TColors.textGrey
        )),
        SizedBox(height: TSizes.spaceBtwSections),
        TextField(
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Описание',
              hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18
              )
          ),
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 18
          ),
          maxLines: 5,
        ),
      ],
    );
  }

  /// Третий шаг заявки
  Widget thirdStep(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Информация о заявке',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: TSizes.spaceBtwSections),
          TextFormField(
            validator: (value) => TValidator.validateEmptyText('ФИО', value),
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.user),
              labelText: 'Фамилия Имя Отчество',
            ),
          ),
          SizedBox(height: TSizes.spaceBtwInputFields),
          TextFormField(
            controller: controller.addressController,
            validator: (value) => TValidator.validateEmptyText('Адрес', value),
            decoration: InputDecoration(
              prefixIcon: Icon(Iconsax.location),
              labelText: 'Адрес',
            ),
            onChanged: (value) {
              controller.fetchAddressSuggestions(value);
            },
          ),

          // Список подсказок адреса
          Obx(() {
            if (controller.addressSuggestions.isEmpty) {
              return SizedBox.shrink();
            }

            return SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: controller.addressSuggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(controller.addressSuggestions[index]),
                    onTap: () {
                      controller.addressController.text = controller.addressSuggestions[index];
                      controller.addressSuggestions.clear();
                    },
                  );
                },
              ),
            );
          }),
          SizedBox(height: TSizes.spaceBtwInputFields),
          IntlPhoneField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: Icon(Iconsax.call),
            ),
            initialCountryCode: 'RU',
          ),
          SizedBox(height: TSizes.spaceBtwInputFields),
          InkWell(
            onTap: () async {
              final result = await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                builder: (context) {
                  return DateAndTimePicker();
                },
              );

              if (result != null && result['date'] != null && result['time'] != null) {
                setState(() {
                  selectedDate = result['date'];
                  selectedTime = result['time'];
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
                    selectedDate != null && selectedTime != null
                        ? '${DateFormat('EEEE, d MMMM', 'ru_RU').format(selectedDate!)} , ${selectedTime!.format(context)}'
                        : 'Выберите дату и время',  // Default text if no date/time selected
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ),
          )

        ],
      ),
    );
  }
}