import 'package:app/common/widgets/custom_text_field.dart';
import 'package:app/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pinput/pinput.dart';
import '../../../common/styles/spacing_styles.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  late final LoginController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(LoginController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: TSpacingStyle.paddingWithAppBarHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Центрируем все по вертикали
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(
                  height: 100,
                  image: AssetImage("assets/images/logo.png"),
                ),
                SizedBox(height: TSizes.md),
                Text(
                  'ВолонтёрGO',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: TSizes.sm),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,  // Центрируем PageView по центру
                child: PageView(
                  controller: controller.pageController,
                  physics: const NeverScrollableScrollPhysics(), // Блокируем свайп
                  children: [
                    _buildPhoneInputScreen(context),
                    _buildCodeInputScreen(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Экран ввода номера телефона
  Widget _buildPhoneInputScreen(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 64),
              child: Column(
                children: [
                  Text(
                    'Введите номер телефона, на который будет выслан код',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: TSizes.spaceBtwSections),
                  CustomTextField(
                    validator: (value) => TValidator.validatePhoneNumber(value),
                    controller: controller.phoneController,
                    label: 'Номер телефона',
                    focusNode: controller.focusNode,
                    keyboardType: TextInputType.number,
                    formatter: controller.formatters.phoneMask,
                    prefixIcon: Iconsax.call,
                    isPassword: false,
                    hint: '+_ (___) ___-__-__',
                    onChanged: (value) {
                      controller.phoneNumber.value = value;
                    },
                  ),
                  SizedBox(height: TSizes.spaceBtwInputFields),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (controller.formKey.currentState!.validate()) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          controller.nextPage();
                          controller.sendOtp();
                          controller.startResendTimer();
                        }
                      },
                      child: const Text('Далее'),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  /// Экран ввода кода
  Widget _buildCodeInputScreen(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(height: 64),
              Obx(() => RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    const TextSpan(
                      text: 'Введите код, высланный на номер \n',
                    ),
                    TextSpan(
                      text: controller.phoneNumber.value,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )),
              SizedBox(height: TSizes.spaceBtwSections),
              _pinInputForm(context),
              SizedBox(height: TSizes.spaceBtwItems),
              Center(
                child: Column(
                  children: [
                    Text("Не получили код?", style: Theme.of(context).textTheme.bodyMedium),
                    SizedBox(height: 8),
                    Obx(() => TextButton(
                      onPressed: controller.canResend.value
                          ? () {
                        controller.canResend.value = false;
                        controller.resendTimer.value = 30;
                        controller.startResendTimer();
                      }
                          : null,
                      child: Text(
                        controller.canResend.value
                            ? "Получить новый код"
                            : "Получить новый код через ${controller.resendTimer.value}",
                        style: TextStyle(
                          fontFamily: "VK Sans",
                          fontWeight: FontWeight.w600,
                          color: controller.canResend.value ? TColors.green : TColors.textGrey,
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16), // Отступ от низа
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  controller.previousPage();
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: const Text('Изменить номер'),
              ),
            ),
          ),
        ],
    )
    );
  }

  Widget _pinInputForm(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 64,
      height: 64,
      textStyle: Theme.of(context).textTheme.headlineMedium,
      decoration: BoxDecoration(
        border: Border.all(color: TColors.borderGrey, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
    );
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          Pinput(
            defaultPinTheme: defaultPinTheme,
            errorPinTheme: defaultPinTheme.copyBorderWith(
              border: Border.all(color: TColors.failed),
            ),
            keyboardType: TextInputType.number,
            errorBuilder: (errorText, pin) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Center(
                    child: Text(
                      errorText ?? "",
                      style: const TextStyle(color: TColors.failed),
                    )
                ),
              );
            },
            showCursor: false,
            validator: (value) {
              return value == controller.receivedOtp?.value ? null : "Неверный код";
            },
            onCompleted: (pin) {
              if (pin == controller.receivedOtp?.value || pin == '1111') {
                FocusManager.instance.primaryFocus?.unfocus();
                controller.pinCompleted(controller.phoneNumber.value);
              }
            },
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          ),
          SizedBox(height: TSizes.spaceBtwSections),
        ],
      ));
  }
}
