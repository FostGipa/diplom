import 'package:app/data/models/task_model.dart';
import 'package:app/features/client/home/controllers/task_detail_controller.dart';
import 'package:app/features/client/home/screens/task_edit.dart';
import 'package:app/features/common/screens/chat.dart';
import 'package:app/utils/constants/colors.dart';
import 'package:app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:yandex_maps_mapkit/mapkit_factory.dart';
import 'package:yandex_maps_mapkit/mapkit.dart' as yandex_mapkit;
import 'package:yandex_maps_mapkit/src/bindings/image/image_provider.dart' as yandex_image_provider;
import 'package:yandex_maps_mapkit/yandex_map.dart';
import '../../../../data/models/volunteer_model.dart';

class TaskDetailScreen extends StatefulWidget {
  final TaskModel task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> with SingleTickerProviderStateMixin{

  final TaskDetailController _controller = Get.put(TaskDetailController());
  late final AnimationController _lottieController;
  late final AppLifecycleListener lifecycleListener;
  yandex_mapkit.MapWindow? _mapWindow;
  bool _isMapkitActive = false;

  @override
  void initState() {
    super.initState();
    _controller.loadData();
    _controller.fetchTask(widget.task.id!);
    _controller.initWebSocket();
    _startMapkit();
    _lottieController = AnimationController(vsync: this);

    lifecycleListener = AppLifecycleListener(
      onResume: () {
        _startMapkit();

      },
      onInactive: () {
        _stopMapkit();
      },
    );
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.taskData.value == null) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      return Scaffold(
        body: Stack(
          children: [
            _buildMap(context),
            _buildBottomCard(context),

            Positioned(
              top: 40,
              left: 16,
              child: FloatingActionButton(
                onPressed: () {
                  Get.back();
                },
                backgroundColor: Colors.white,
                elevation: 4,
                shape: CircleBorder(),
                child: Icon(Iconsax.arrow_left_2, color: Colors.black),
              ),
            ),

            Positioned(
              top: 40,
              right: 16,
              child: FloatingActionButton(
                onPressed: () {
                  _controller.openYandexMaps(_controller.latitude!, _controller.longitude!);
                },
                backgroundColor: Colors.white,
                elevation: 4,
                shape: CircleBorder(),
                child: Icon(Iconsax.map, color: Colors.black), // Можно заменить иконку
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMap(BuildContext context) {
    return Positioned.fill(
      child: YandexMap(
        onMapCreated: (mapWindow) {
          _mapWindow = mapWindow;
          if (_controller.latitude != null && _controller.longitude != null) {
            _mapWindow?.map.move(
              yandex_mapkit.CameraPosition(
                yandex_mapkit.Point(
                  latitude: _controller.latitude!,
                  longitude: _controller.longitude!,
                ),
                zoom: 15.0,
                azimuth: 100.0,
                tilt: 90.0,
              ),
            );
            _mapWindow?.map.mapObjects.addPlacemark()
              ?..geometry = yandex_mapkit.Point(latitude: _controller.latitude!, longitude: _controller.longitude!)
              ..setIcon(yandex_image_provider.ImageProvider.fromImageProvider(ResizeImage(AssetImage("assets/images/user_pin.png"), width: 128, height: 128)));
          }
        },
      ),
    );
  }

  Widget _buildBottomCard(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          color: _controller.panelHeight.value > 0.3
              ? Colors.black.withValues(alpha: 0.5) // Затемняем фон
              : Colors.transparent, // Прозрачный, если панель свернута
        ),

        DraggableScrollableSheet(
          initialChildSize: 0.3,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 300), // Анимация появления
              curve: Curves.easeOut, // Плавный эффект
              decoration: BoxDecoration(
                color: Colors.white, // Полупрозрачный фон
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 10),
                ],
              ),
              padding: EdgeInsets.all(TSizes.defaultSpace),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    SizedBox(height: TSizes.spaceBtwSections),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Obx(() {
                        final task = _controller.taskData.value;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCategoryChips(task!.taskCategories),
                            SizedBox(height: TSizes.spaceBtwItems),
                            _title(task.taskName),
                            SizedBox(height: TSizes.spaceBtwItems),
                            Text(task.taskDescription, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                            SizedBox(height: TSizes.spaceBtwItems),
                            Text("Комментарий: ${task.taskComment}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                            SizedBox(height: TSizes.spaceBtwSections),
                            _title('Действия'),
                            SizedBox(height: TSizes.spaceBtwItems),
                            _actionButtons(),
                            SizedBox(height: TSizes.spaceBtwSections),
                            _title('Информация'),
                            SizedBox(height: TSizes.spaceBtwItems),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade300),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  _buildInfoRow(Iconsax.calendar_add, _formatDate(task.taskStartDate), task.taskStartTime, ""),
                                  SizedBox(height: TSizes.spaceBtwInputFields),
                                  _buildInfoRow(Iconsax.location, task.taskAddress, "", ""),
                                  SizedBox(height: 12),
                                  _buildInfoRow(Iconsax.user, "${task.client?.lastName} ${task.client?.name}", _controller.formatDate(task.client!.dateOfBirth), "Рейтинг: ${task.client!.rating!}"),
                                ],
                              )
                            ),
                            SizedBox(height: TSizes.spaceBtwSections),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Волонтеры ',
                                    style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, // не забудь указать цвет
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${_controller.getVolunteersCount(task.volunteers!)}/${task.taskVolunteersCount}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: TColors.textGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: TSizes.spaceBtwItems),
                            Obx(() => _buildVolunteerList(_controller.volunteers.toList())),
                            SizedBox(height: TSizes.spaceBtwSections),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    await Future.delayed(Duration(seconds: 1), () {
                                      if (_controller.taskData.value?.taskStatus == 'В процессе' || _controller.taskData.value?.taskStatus == 'Готова') {
                                        endTask();
                                      }
                                    });
                                  },
                                  child: Text('Завершить заявку')
                              ),
                            ),
                            SizedBox(height: TSizes.spaceBtwSections),
                          ],
                        );
                      })
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Text _title(String text) => Text(text, style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold));

  Container _actionButtons() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Get.to(ChatScreen(taskId: _controller.taskData.value?.id, userId: _controller.userData.value?.idUser));
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Iconsax.message),
                  SizedBox(height: 8),
                  Text(
                    'Чат',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Get.to(TaskEditScreen(taskId: _controller.taskData.value!.id!));
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Iconsax.edit),
                  SizedBox(height: 8),
                  Text(
                    'Редакт.',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Подтверждение'),
                    content: const Text('Вы уверены, что хотите отменить заявку?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text('Нет'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          minimumSize: const Size(0, 40),
                        ),
                        onPressed: () {
                          _controller.cancelTask(_controller.taskData.value!.id!);
                          Get.back();
                          Get.back();
                        },
                        child: const Text('Да, отменить'),
                      ),
                    ],
                  ),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Iconsax.clipboard_close),
                  SizedBox(height: 8),
                  Text(
                    'Отменить',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVolunteerList(List<Volunteer>? volunteers) {
    if (volunteers == null || volunteers.isEmpty) {
      return Center(
        child: Text(
          "Нет доступных волонтеров",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    // Фильтруем пустые записи
    volunteers = volunteers.where((v) =>
    v.name.isNotEmpty || v.lastName.isNotEmpty || v.phoneNumber.isNotEmpty
    ).toList();

    if (volunteers.isEmpty) {
      return Center(
        child: Text(
          "Нет доступных волонтеров",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: volunteers.length,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return VolunteerCard(
          volunteer: volunteers![index],
          controller: _controller,
          taskId: _controller.taskData.value!.id!,
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: TSizes.spaceBtwInputFields);
      },
    );
  }

  Widget _buildCategoryChips(List<String> categories) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: categories.map((category) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: TColors.green,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            category,
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInfoRow(IconData icon, String line1, String? line2, String? line3) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 25),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line1,
                  style: TextStyle(fontSize: 18),
                  softWrap: true,
                ),
                if (line2 != null && line2.isNotEmpty)
                  Text(
                    line2,
                    style: TextStyle(fontSize: 18),
                    softWrap: true,
                  ),
                if (line3 != null && line3.isNotEmpty)
                  Text(
                    line3,
                    style: TextStyle(fontSize: 18),
                    softWrap: true,
                  ),
              ],
            ),
          ),
        ],
    );
  }

  String _formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      String weekday = DateFormat('EEEE', 'ru').format(parsedDate);
      String monthNominative = DateFormat('MMMM', 'ru').format(parsedDate);
      String day = DateFormat('d', 'ru').format(parsedDate);

      Map<String, String> monthGenitive = {
        "январь": "января",
        "февраль": "февраля",
        "март": "марта",
        "апрель": "апреля",
        "май": "мая",
        "июнь": "июня",
        "июль": "июля",
        "август": "августа",
        "сентябрь": "сентября",
        "октябрь": "октября",
        "ноябрь": "ноября",
        "декабрь": "декабря"
      };

      weekday = weekday[0].toUpperCase() + weekday.substring(1);
      String month = monthGenitive[monthNominative.toLowerCase()] ?? monthNominative;

      return "$weekday, $day $month";
    } catch (e) {
      return date;
    }
  }

  void _startMapkit() {
    if (!_isMapkitActive) {
      _isMapkitActive = true;
      mapkit.onStart();
    }
  }

  void _stopMapkit() {
    if (_isMapkitActive) {
      _isMapkitActive = false;
      mapkit.onStop();
    }
  }

  void endTask() {
    Get.dialog(AlertDialog(
      title: Text("Подтвердите завершение", textAlign: TextAlign.center,),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Для завершения заявки волонтер должен отсканировать QR код.",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 200,
              height: 200,
              child: QrImageView(
                data: _controller.taskData.value!.id.toString(),
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text("Закрыть"),
        ),
      ],
    ));
  }
}

class VolunteerCard extends StatefulWidget {
  final Volunteer volunteer;
  final TaskDetailController controller;
  final int taskId; // Добавь taskId, чтобы знать к какой заявке относится волонтёр

  VolunteerCard({
    required this.volunteer,
    required this.controller,
    required this.taskId,
  });

  @override
  _VolunteerCardState createState() => _VolunteerCardState();
}

class _VolunteerCardState extends State<VolunteerCard> with SingleTickerProviderStateMixin {
  bool _expanded = false;

  void _showConfirmDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Запросить другого волонтера?'),
        content: Text('Вы уверены, что хотите отказаться от этого волонтера?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Да'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      widget.controller.cancelParticipation(widget.taskId, widget.volunteer.idVolunteer!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.volunteer.idVolunteer),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        _showConfirmDialog();
        return false; // чтобы карточка не удалялась визуально
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.person_off, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: () => setState(() => _expanded = !_expanded),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.grey.shade300,
                    child: Icon(Iconsax.user),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.volunteer.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Волонтер",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Iconsax.archive_book, color: Colors.grey),
                        onPressed: () {
                          widget.controller.openPdfUrl(widget.volunteer.dobroId!);
                        },
                      ),
                      IconButton(
                        icon: Icon(Iconsax.call, color: Colors.grey),
                        onPressed: () {
                          widget.controller.makePhoneCall(widget.volunteer.phoneNumber);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              AnimatedSize(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: _expanded
                    ? Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(),
                      SizedBox(height: 8),
                      Text("Рейтинг: ${widget.volunteer.rating}"),
                      SizedBox(height: 4),
                      Text("Добрые дела: ${widget.volunteer.completedTasks}"),
                      SizedBox(height: 4),
                      Text("Часы помощи: ${widget.volunteer.helpHours}"),
                    ],
                  ),
                )
                    : SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

