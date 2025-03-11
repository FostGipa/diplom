import 'package:app/utils/device/device_utility.dart';
import 'package:app/utils/loaders/loaders.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/custom_shaper/containers/primary_header_container.dart';
import '../../../../data/task_model.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../widgets/home_appbar.dart';

class VolunteerHomeScreen extends StatefulWidget {
  const VolunteerHomeScreen({super.key});

  @override
  State<VolunteerHomeScreen> createState() => VolunteerHomeScreenState();
}

class VolunteerHomeScreenState extends State<VolunteerHomeScreen> {
  TaskModel? _task;
  List<TaskModel> _tasks = [];

  @override
  void initState() {
    super.initState();
  }

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
                  ],
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
              Text(
                "Активная заявка",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: TSizes.spaceBtwItems),
              _task != null && _task!.taskStatus == 'Активна'
                  ? GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (BuildContext context) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _task!.taskName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 25,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                _task!.taskDescription,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 32),
                              Text(
                                'Информация',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 25,
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(Iconsax.calendar_1, color: Colors.black),
                                  SizedBox(width: 8),
                                  Text(
                                    _task!.taskStartDate,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(Iconsax.map, color: Colors.black),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _task!.taskAddress,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18,
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(Iconsax.user, color: Colors.black),
                                  SizedBox(width: 8),
                                  // Text(
                                  //   '${_task!.taskClient.firstName} ${_task!.taskClient.lastName}',
                                  //   style: TextStyle(
                                  //     fontWeight: FontWeight.w400,
                                  //     fontSize: 18,
                                  //   ),
                                  // ),
                                ],
                              ),
                              SizedBox(height: 32),
                              // Добавляем свайп-кнопку внизу
                              SwipeButton(
                                onAccept: () {},
                              ),
                              SizedBox(height: TSizes.spaceBtwItems)
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: SizedBox(
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
                            _task!.taskName,
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
                                _task!.taskStartDate,
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
              )
                  : Center(child: Text('Нет заявок')),
              SizedBox(height: TSizes.spaceBtwSections),
              Text(
                "Список заявок",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: TSizes.spaceBtwItems),
              // FutureBuilder<List<TaskModel>>(
              //   future: _firebaseService.getAllTasks(),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return Center(child: CircularProgressIndicator());
              //     } else if (snapshot.hasError) {
              //       return Center(child: Text('Ошибка: ${snapshot.error}'));
              //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              //       return Center(child: Text('Задачи не найдены'));
              //     } else {
              //       final tasks = snapshot.data!;
              //       return ListView.builder(
              //         shrinkWrap: true,
              //         physics: NeverScrollableScrollPhysics(),
              //         itemCount: tasks.length,
              //         itemBuilder: (context, index) {
              //           final task = tasks[index];
              //           // Пропускаем активную заявку
              //           if (_task != null && task.taskStatus == 'Активна') {
              //             return SizedBox.shrink(); // Пропускаем активную заявку
              //           }
              //           return GestureDetector(
              //             onTap: () {
              //               showModalBottomSheet(
              //                 context: context,
              //                 isScrollControlled: true,
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              //                 ),
              //                 builder: (BuildContext context) {
              //                   return Container(
              //                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              //                     child: SingleChildScrollView(
              //                       child: Column(
              //                         crossAxisAlignment: CrossAxisAlignment.start,
              //                         children: [
              //                           Text(
              //                             task.taskName,
              //                             style: TextStyle(
              //                               fontWeight: FontWeight.w600,
              //                               fontSize: 25,
              //                             ),
              //                           ),
              //                           SizedBox(height: 16),
              //                           Text(
              //                             task.taskDescription,
              //                             style: TextStyle(
              //                               fontWeight: FontWeight.w400,
              //                               fontSize: 18,
              //                             ),
              //                           ),
              //                           SizedBox(height: 32),
              //                           Text(
              //                             'Информация',
              //                             style: TextStyle(
              //                               fontWeight: FontWeight.w600,
              //                               fontSize: 25,
              //                             ),
              //                           ),
              //                           SizedBox(height: 16),
              //                           Row(
              //                             children: [
              //                               Icon(Iconsax.calendar_1, color: Colors.black),
              //                               SizedBox(width: 8),
              //                               Text(
              //                                 task.taskStartDate,
              //                                 style: TextStyle(
              //                                   fontWeight: FontWeight.w400,
              //                                   fontSize: 18,
              //                                 ),
              //                               ),
              //                             ],
              //                           ),
              //                           SizedBox(height: 16),
              //                           Row(
              //                             children: [
              //                               Icon(Iconsax.map, color: Colors.black),
              //                               SizedBox(width: 8),
              //                               Expanded(
              //                                 child: Text(
              //                                   task.taskAddress,
              //                                   style: TextStyle(
              //                                     fontWeight: FontWeight.w400,
              //                                     fontSize: 18,
              //                                   ),
              //                                   softWrap: true,
              //                                 ),
              //                               ),
              //                             ],
              //                           ),
              //                           SizedBox(height: 16),
              //                           Row(
              //                             children: [
              //                               Icon(Iconsax.user, color: Colors.black),
              //                               SizedBox(width: 8),
              //                               Text(
              //                                 '${task.taskClient.firstName} ${task.taskClient.lastName}',
              //                                 style: TextStyle(
              //                                   fontWeight: FontWeight.w400,
              //                                   fontSize: 18,
              //                                 ),
              //                               ),
              //                             ],
              //                           ),
              //                           SizedBox(height: 32),
              //                           // Добавляем свайп-кнопку внизу
              //                           SwipeButton(
              //                             task: task,
              //                             onAccept: () => _acceptTask,
              //                           ),
              //                           SizedBox(height: TSizes.spaceBtwItems)
              //                         ],
              //                       ),
              //                     ),
              //                   );
              //                 },
              //               );
              //             },
              //             child: SizedBox(
              //               width: TDeviceUtils.getScreenWight(context),
              //               child: Stack(
              //                 children: [
              //                   TPrimaryHeaderContainer(
              //                     backgroundColor: Colors.white,
              //                     circularColor: TColors.green.withOpacity(0.2),
              //                     child: Padding(
              //                       padding: EdgeInsets.all(TSizes.lg),
              //                       child: Column(
              //                         crossAxisAlignment: CrossAxisAlignment.start,
              //                         children: [
              //                           Text(
              //                             "Помощь по дому",
              //                             style: TextStyle(
              //                               fontSize: 18,
              //                               fontWeight: FontWeight.w400,
              //                               color: TColors.green,
              //                             ),
              //                           ),
              //                           SizedBox(height: TSizes.sm),
              //                           Text(
              //                             task.taskName,
              //                             style: TextStyle(
              //                               fontSize: 20,
              //                               fontWeight: FontWeight.w600,
              //                               color: Colors.black,
              //                             ),
              //                             softWrap: true,
              //                           ),
              //                           SizedBox(height: TSizes.spaceBtwInputFields),
              //                           Row(
              //                             children: [
              //                               Icon(Iconsax.calendar_1, color: Colors.black),
              //                               SizedBox(width: TSizes.sm),
              //                               Column(
              //                                 crossAxisAlignment: CrossAxisAlignment.start,
              //                                 children: [
              //                                   Text(
              //                                     task.taskStartDate,
              //                                     style: TextStyle(
              //                                       fontSize: 16,
              //                                       fontWeight: FontWeight.w400,
              //                                       color: Colors.black,
              //                                     ),
              //                                   ),
              //                                   Text(
              //                                     task.taskStartTime,
              //                                     style: TextStyle(
              //                                       fontSize: 16,
              //                                       fontWeight: FontWeight.w400,
              //                                       color: Colors.black,
              //                                     ),
              //                                   ),
              //                                 ],
              //                               ),
              //                             ],
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //                   ),
              //                   Positioned(
              //                     right: TSizes.lg, // Отступ справа
              //                     bottom: TSizes.lg,  // Отступ сверху
              //                     child: Row(
              //                       children: [
              //                         Icon(Iconsax.user),
              //                         SizedBox(width: TSizes.xs),
              //                         Text(
              //                           task.taskVolunteersCount.toString(),
              //                           style: TextStyle(
              //                             fontSize: 18,
              //                             fontWeight: FontWeight.w400,
              //                             color: Colors.black,
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           );
              //         },
              //       );
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class SwipeButton extends StatefulWidget {
  final VoidCallback onAccept;

  const SwipeButton({
    super.key,
    required this.onAccept,
  });

  @override
  _SwipeButtonState createState() => _SwipeButtonState();
}

class _SwipeButtonState extends State<SwipeButton> {
  double dragPosition = 0.0;
  final double circleSize = 50; // Размер белой области (круга)
  final double padding = 5; // Отступы сверху и снизу внутри зелёной области

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width; // Ширина экрана
    final double maxDrag = screenWidth - 2 * padding - circleSize - 32; // Максимальная длина свайпа внутри зелёной области

    // Вычисляем текущий цвет фона
    final double colorTween = dragPosition / maxDrag;
    final Color currentColor = Color.lerp(Colors.green, Colors.white, colorTween)!;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          dragPosition += details.delta.dx;
          if (dragPosition < 0) dragPosition = 0; // Ограничение влево
          if (dragPosition > maxDrag) dragPosition = maxDrag; // Ограничение вправо
        });
      },
      onHorizontalDragEnd: (details) {
        if (dragPosition >= maxDrag) {
          // Завершено свайп-действие
          widget.onAccept(); // Вызываем колбэк для принятия задачи
        } else {
          // Возврат в начальную позицию, если свайп не завершён
          setState(() {
            dragPosition = 0;
          });
        }
      },
      child: Container(
        width: screenWidth, // Кнопка на всю ширину экрана
        padding: EdgeInsets.symmetric(horizontal: padding), // Отступы внутри зелёной области
        decoration: BoxDecoration(
          color: currentColor, // Текущий цвет фона
          borderRadius: BorderRadius.circular(50), // Закруглённые углы
        ),
        height: circleSize + (padding * 2), // Высота кнопки с учётом вертикальных отступов
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Зеленая кнопка (фон)
            Positioned.fill(
              child: Center(
                child: const Text(
                  'Принять заявку',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Белая движущаяся часть (свайп-область)
            Positioned(
              left: dragPosition, // Расположение белого круга
              child: Container(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_forward, color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}