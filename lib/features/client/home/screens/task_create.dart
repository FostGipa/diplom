import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../../common/widgets/custom_date_time_picker.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/validators/banned_words.dart';
import '../../../../utils/validators/validation.dart';
import '../controllers/task_create_controller.dart';

class ClientTaskCreateScreen extends StatefulWidget {
  const ClientTaskCreateScreen({super.key});

  @override
  State<ClientTaskCreateScreen> createState() => _ClientTaskCreateScreenState();
}

class _ClientTaskCreateScreenState extends State<ClientTaskCreateScreen> {

  final TaskCreateController controller = Get.put(TaskCreateController());
  final BannedWords bannedWords = BannedWords();

  @override
  void initState() {
    super.initState();
    controller.loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(onPressed: () {
          if (controller.currentStep > 0) {
            controller.previousPage();
          } else {
            Get.back(); // Возврат назад, если это первый этап
          }
        }, icon: Icon(Iconsax.arrow_left_2)),
        title: Text('Новая заявка', style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 24,
        )),
      ),
      body: Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            /// PageView для шагов
            Expanded(
              child: PageView(
                controller: controller.pageController,
                physics: NeverScrollableScrollPhysics(),
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите название задачи';
                }
                if (controller.bannedWords.containsBadWords(value)) {
                  return 'Содержит недопустимые слова';
                }
                return null;
              },
              prefixIcon: Iconsax.document,
              label: 'Название',
              onChanged: (_) => controller.validateSecondPage(),
            ),
            SizedBox(height: TSizes.spaceBtwInputFields),

            // Поле "Описание"
            TextFormField(
              controller: controller.taskDescription,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Подробно опишите задачу',
              ),
              maxLines: 5,
              style: TextStyle(fontSize: 18),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите описание задачи';
                }
                if (controller.bannedWords.containsBadWords(value)) {
                  return 'Содержит недопустимые слова';
                }
                return null;
              },
              onChanged: (_) => controller.validateSecondPage(),
            ),
            SizedBox(height: TSizes.spaceBtwInputFields),

            // Поле "Количество волонтеров"
            CustomTextField(
              controller: controller.taskVolunteersCount,
              prefixIcon: Iconsax.profile_2user,
              label: 'Кол-во волонтеров',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите количество';
                }
                if (int.tryParse(value) == null || int.parse(value) <= 0) {
                  return 'Введите число больше 0';
                }
                if (int.parse(value) > 3) {
                  return 'Максимальное кол-во волонтеров - 3';
                }
                return null;
              },
              onChanged: (_) => controller.validateSecondPage(),
            ),
            SizedBox(height: TSizes.spaceBtwInputFields),

            // Поле "Продолжительность"
            CustomTextField(
              controller: controller.taskDuration,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Выберите продолжительность';
                }
                return null;
              },
              prefixIcon: Iconsax.timer,
              label: 'Продолжительность',
              readOnly: true,
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  controller.taskDuration.text = time.format(context);
                  controller.validateSecondPage();
                }
              },
            ),
            SizedBox(height: TSizes.spaceBtwInputFields),

            // Поле "Комментарий" (необязательное)
            TextFormField(
              controller: controller.taskComment,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Комментарий (необязательно)',
              ),
              style: TextStyle(fontSize: 18),
              maxLines: 3,
              validator: (value) {
                if (value != null && value.isNotEmpty &&
                    controller.bannedWords.containsBadWords(value)) {
                  return 'Содержит недопустимые слова';
                }
                return null;
              },
              onChanged: (_) => controller.validateSecondPage(),
            ),

            SizedBox(height: TSizes.spaceBtwSections),

            // Кнопка "Далее"
            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isSecondPageValid.value
                    ? () => controller.nextPage()
                    : null,
                child: Text("Далее"),
              ),
            )),
            SizedBox(height: TSizes.spaceBtwSections),
          ],
        ),
      ),
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
            Text(
                'Контактная информация',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)
            ),
            SizedBox(height: TSizes.spaceBtwSections),

            // Поле ФИО
            CustomTextField(
              controller: controller.fullName,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите ФИО';
                }
                if (value.split(' ').length < 2) {
                  return 'Введите полное ФИО (минимум имя и фамилию)';
                }
                return null;
              },
              prefixIcon: Iconsax.user,
              label: 'Фамилия Имя Отчество',
              onChanged: (_) => controller.validateThirdPage(),
            ),
            SizedBox(height: TSizes.spaceBtwInputFields),

            // Поле телефона
            CustomTextField(
              controller: controller.phoneController,
              validator: (value) => TValidator.validatePhoneNumber(value),
              label: 'Номер телефона',
              keyboardType: TextInputType.phone,
              formatter: controller.formatters.phoneMask,
              prefixIcon: Iconsax.call,
              hint: '+7 (___) ___-__-__',
              onChanged: (_) => controller.validateThirdPage(),
            ),
            SizedBox(height: TSizes.spaceBtwInputFields),

            // Поле адреса
            CustomTextField(
              controller: controller.taskAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите адрес';
                }
                if (value.length < 10) {
                  return 'Адрес слишком короткий';
                }
                return null;
              },
              prefixIcon: Iconsax.location,
              label: 'Адрес',
              onChanged: (value) {
                controller.fetchAddressSuggestions(value);
                controller.validateThirdPage();
              },
            ),

            // Подсказки адреса
            Obx(() {
              if (controller.addressSuggestions.isEmpty) {
                return SizedBox.shrink();
              }
              return Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.addressSuggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(controller.addressSuggestions[index]),
                      onTap: () {
                        controller.taskAddress.text = controller.addressSuggestions[index];
                        controller.addressSuggestions.clear();
                        controller.validateThirdPage();
                      },
                    );
                  },
                ),
              );
            }),
            SizedBox(height: TSizes.spaceBtwInputFields),

            // Выбор даты и времени
            InkWell(
              onTap: () async {
                final result = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20)),
                  ),
                  builder: (context) => DateAndTimePicker(),
                );

                if (result != null) {
                  setState(() {
                    controller.selectedDate = result['date'];
                    controller.selectedTime = result['time'];
                    controller.taskStartDate.text =
                        DateFormat('yyyy-MM-dd').format(controller.selectedDate!);
                    controller.taskStartTime.text =
                        controller.selectedTime!.format(context);
                  });
                  controller.validateThirdPage();
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(Iconsax.calendar, color: Colors.grey),
                    SizedBox(width: TSizes.md),
                    Text(
                      controller.selectedDate != null && controller.selectedTime != null
                          ? '${DateFormat('EEEE, d MMMM', 'ru_RU').format(controller.selectedDate!)} , ${controller.selectedTime!.format(context)}'
                          : 'Выберите дату и время',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: TSizes.spaceBtwSections),

            // Кнопка отправки
            Obx(() {
              final isValid = controller.isThirdPageValid.value;
              final isDateSelected = controller.selectedDate != null &&
                  controller.selectedTime != null;

              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isValid && isDateSelected
                      ? () => controller.sendTask()
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    "Отправить заявку",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              );
            }),
            SizedBox(height: TSizes.spaceBtwSections),
          ],
        ),
      ),
    );
  }
}
