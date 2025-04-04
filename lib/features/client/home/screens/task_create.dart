import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../common/styles/spacing_styles.dart';
import '../../../../common/widgets/custom_date_time_picker.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/validators/validation.dart';
import '../controllers/task_create_controller.dart';

class ClientTaskCreateScreen extends StatefulWidget {
  const ClientTaskCreateScreen({super.key});

  @override
  State<ClientTaskCreateScreen> createState() => _ClientTaskCreateScreenState();
}

class _ClientTaskCreateScreenState extends State<ClientTaskCreateScreen> {
  final TaskCreateController controller = Get.put(TaskCreateController());

  @override
  void initState() {
    super.initState();
    controller.loadUserData();
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: controller.currentStep > 0 ? controller.previousPage : null,
                ),
              ],
            ),
            SizedBox(height: TSizes.spaceBtwItems),

            /// PageView для шагов
            Expanded(
              child: PageView(
                controller: controller.pageController,
                physics: NeverScrollableScrollPhysics(), // Запрещаем свайпы, управляем программно
                onPageChanged: (index) {
                  setState(() {
                    controller.currentStep = index;
                  });
                },
                children: [
                  firstStep(),
                  secondStep(),
                  thirdStep(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Первый шаг заявки
  Widget firstStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Выберите услуги', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
          SizedBox(height: TSizes.spaceBtwItems),
          Text(
            'Выберите одну или несколько необходимых услуг',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: TSizes.spaceBtwSections),
          // Генерация чекбоксов
          Column(
            children: List.generate(controller.services.length, (index) {
              return Obx(() => CheckboxListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.services[index]["title"]!,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                    if (controller.services[index]["subtitle"]!.isNotEmpty) SizedBox(height: 4),
                    if (controller.services[index]["subtitle"]!.isNotEmpty)
                      Text(controller.services[index]["subtitle"]!,
                          style: TextStyle(fontSize: 18, color: Colors.grey)),
                  ],
                ),
                value: controller.selectedServices[index],
                onChanged: (value) => controller.toggleService(index, value ?? false),
              ));
            }),
          ),
          SizedBox(height: TSizes.spaceBtwSections),
          Obx(() {
            bool isAnySelected = controller.selectedServices.contains(true);
            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isAnySelected ? () => controller.nextPage() : null,
                child: Text("Далее"),
              ),
            );
          }),
          SizedBox(height: TSizes.spaceBtwSections),
        ],
      ),
    );
  }

  /// Второй шаг заявки
  Widget secondStep() {
    return SingleChildScrollView(
      child: Form(
        key: controller.secondFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Информация о заявке', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
            SizedBox(height: TSizes.spaceBtwItems),
            Text('Подробно распишите, что требуется сделать',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18, color: TColors.textGrey)),
            SizedBox(height: TSizes.spaceBtwSections),
            CustomTextField(
              controller: controller.taskName,
              validator: (value) => TValidator.validateEmptyText('Название', value),
              prefixIcon: Iconsax.document,
              label: 'Название',
              keyboardType: TextInputType.number,
              onChanged: (value) => controller.validateField(0, value),
            ),
            SizedBox(height: TSizes.spaceBtwInputFields),
            TextField(
              controller: controller.taskDescription,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Описание', hintStyle: TextStyle(fontSize: 18)),
              style: TextStyle(fontSize: 18),
              maxLines: 5,
              onChanged: (value) => controller.validateField(1, value),
            ),
            SizedBox(height: TSizes.spaceBtwInputFields),
            CustomTextField(
              controller: controller.taskVolunteersCount,
              validator: (value) => TValidator.validateEmptyText('Кол-во', value),
              prefixIcon: Iconsax.profile_2user,
              label: 'Кол-во требуемых волонтеров',
              keyboardType: TextInputType.number,
              onChanged: (value) => controller.validateField(2, value),
            ),
            SizedBox(height: TSizes.spaceBtwInputFields),
            CustomTextField(
              controller: controller.taskDuration,
              validator: (value) => TValidator.validateEmptyText('Продолжительность', value),
              prefixIcon: Iconsax.timer,
              label: 'Продолжительность',
              readOnly: true,
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (pickedTime != null) {
                  String formattedTime = pickedTime.format(context);
                  controller.taskDuration.text = formattedTime;
                  controller.updateDurationField(formattedTime);
                }
              },
            ),

            SizedBox(height: TSizes.spaceBtwInputFields),
            TextField(
              controller: controller.taskComment,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Комментарий', hintStyle: TextStyle(fontSize: 18)),
              style: TextStyle(fontSize: 18),
              maxLines: 5,
            ),
            SizedBox(height: TSizes.spaceBtwSections),
            Obx(() {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isFormValid.value ? () => controller.nextPage() : null,
                  child: Text("Далее"),
                ),
              );
            }),
            SizedBox(height: TSizes.spaceBtwSections),
          ],
        ),
      )
    );
  }

  /// Третий шаг заявки
  Widget thirdStep() {
    return SingleChildScrollView(
      child: Form(
        key: controller.thirdFormKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Информация о заявке', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
              SizedBox(height: TSizes.spaceBtwSections),
              CustomTextField(
                validator: (value) => TValidator.validateEmptyText('ФИО', value),
                prefixIcon: Iconsax.user,
                label: 'Фамилия Имя Отчество',
                controller: controller.fullName,
              ),
              SizedBox(height: TSizes.spaceBtwInputFields),
              CustomTextField(
                validator: (value) => TValidator.validatePhoneNumber(value),
                controller: controller.phoneController,
                label: 'Номер телефона',
                keyboardType: TextInputType.number,
                formatter: controller.formatters.phoneMask,
                prefixIcon: Iconsax.call,
                hint: '+7 (___) ___-__-__',
              ),
              SizedBox(height: TSizes.spaceBtwInputFields),
              CustomTextField(
                controller: controller.taskAddress,
                validator: (value) => TValidator.validateEmptyText('Адрес', value),
                prefixIcon: Iconsax.location,
                label: 'Адрес',
                onChanged: (value) {
                  controller.fetchAddressSuggestions(value);
                },
              ),
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
                          controller.taskAddress.text = controller.addressSuggestions[index];
                          controller.addressSuggestions.clear();
                        },
                      );
                    },
                  ),
                );
              }),

              SizedBox(height: TSizes.spaceBtwInputFields),
              InkWell(
                onTap: () async {
                  final result = await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                    builder: (context) => DateAndTimePicker(),
                  );

                  if (result != null && result['date'] != null && result['time'] != null) {
                    setState(() {
                      controller.selectedDate = result['date'];
                      controller.selectedTime = result['time'];

                      controller.taskStartDate.text = DateFormat('yyyy-MM-dd').format(controller.selectedDate!);
                      controller.taskStartTime.text = controller.selectedTime!.format(context);
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(14)),
                  child: Row(
                    children: [
                      Icon(Iconsax.calendar, color: Colors.grey),
                      SizedBox(width: TSizes.md),
                      Text(
                        controller.selectedDate != null && controller.selectedTime != null
                            ? '${DateFormat('EEEE, d MMMM', 'ru_RU').format(controller.selectedDate!)} , ${controller.selectedTime!.format(context)}'
                            : 'Выберите дату и время',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: TSizes.spaceBtwInputFields),
              OutlinedButton(onPressed: controller.sendTask, child: Text("Отправить заявку")),
            ],
        )
      ),
    );
  }
}
