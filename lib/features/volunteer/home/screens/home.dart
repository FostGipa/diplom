import 'package:app/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/custom_shaper/containers/primary_header_container.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../widgets/home_appbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                THomeAppBar(),

                SizedBox(height: TSizes.spaceBtwItems),

                Container(
                  width: TDeviceUtils.getScreenWight(context),
                  padding: const EdgeInsets.all(TSizes.md),
                  decoration: BoxDecoration(
                    color: TColors.grey,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: TColors.borderGrey),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        spreadRadius: 0.5,
                        blurRadius: 2,
                        offset: Offset(0, 1.5),
                      )
                    ]
                  ),
                  child: Row(
                    children: [
                      const Icon(Iconsax.search_normal, color: Colors.black12),
                      const SizedBox(width: TSizes.spaceBtwItems),
                      Text('Поиск', style: Theme.of(context).textTheme.bodySmall)
                    ],
                  ),
                ),

                SizedBox(height: TSizes.spaceBtwSections),

                Text("Активная заявка", style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 24
                )),

                SizedBox(height: TSizes.spaceBtwItems),

                SizedBox(
                  width: TDeviceUtils.getScreenWight(context),
                  child: TPrimaryHeaderContainer(
                    backgroundColor: TColors.green,
                    circularColor: Colors.white.withOpacity(0.1),
                    child: Padding(
                      padding: EdgeInsets.all(TSizes.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Помощь по дому",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: TSizes.sm),
                          Text(
                            "Уборка квартиры после болезни",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            softWrap: true,
                          ),
                          SizedBox(height: TSizes.spaceBtwInputFields),
                          Row(
                            children: [
                              Icon(Iconsax.calendar_1, color: Colors.white),
                              SizedBox(width: TSizes.sm),
                              Text(
                                "19 января",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: TSizes.spaceBtwSections),

                Text("Список заявок", style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 24
                )),

                SizedBox(height: TSizes.spaceBtwItems),

                SizedBox(
                  width: TDeviceUtils.getScreenWight(context),
                  child: TPrimaryHeaderContainer(
                    backgroundColor: Colors.white,
                    circularColor: TColors.green.withOpacity(0.2),
                    child: Padding(
                      padding: EdgeInsets.all(TSizes.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Помощь по дому",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: TColors.green,
                            ),
                          ),
                          SizedBox(height: TSizes.sm),
                          Text(
                            "Уборка квартиры после болезни",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            softWrap: true,
                          ),
                          SizedBox(height: TSizes.spaceBtwInputFields),
                          Row(
                            children: [
                              Icon(Iconsax.calendar_1, color: Colors.black),
                              SizedBox(width: TSizes.sm),
                              Text(
                                "19 января",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: TSizes.spaceBtwItems),

                SizedBox(
                  width: TDeviceUtils.getScreenWight(context),
                  child: TPrimaryHeaderContainer(
                    backgroundColor: Colors.white,
                    circularColor: TColors.green.withOpacity(0.2),
                    child: Padding(
                      padding: EdgeInsets.all(TSizes.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Помощь по дому",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: TColors.green,
                            ),
                          ),
                          SizedBox(height: TSizes.sm),
                          Text(
                            "Уборка квартиры после болезни",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            softWrap: true,
                          ),
                          SizedBox(height: TSizes.spaceBtwInputFields),
                          Row(
                            children: [
                              Icon(Iconsax.calendar_1, color: Colors.black),
                              SizedBox(width: TSizes.sm),
                              Text(
                                "19 января",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]
          ),
        )
      )
    );
  }
}