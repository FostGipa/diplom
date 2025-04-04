import 'package:app/common/widgets/custom_swipe_button.dart';
import 'package:app/data/models/task_model.dart';
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
import '../controllers/volunteer_task_detail_controller.dart';

class VolunteerTaskDetail extends StatefulWidget {
  final TaskModel task;

  const VolunteerTaskDetail({super.key, required this.task});

  @override
  State<VolunteerTaskDetail> createState() => VolunteerTaskDetailState();
}

class VolunteerTaskDetailState extends State<VolunteerTaskDetail> {

  final VolunteerTaskDetailController _controller = Get.put(VolunteerTaskDetailController());

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
              ? Colors.black.withOpacity(0.5) // Затемняем фон
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
                              Text(task.taskName, style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                              SizedBox(height: TSizes.spaceBtwItems),
                              Text(task.taskDescription, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                              SizedBox(height: TSizes.spaceBtwItems),
                              Text("Комментарий: ${task.taskComment}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                              SizedBox(height: TSizes.spaceBtwSections),
                              Text('Информация', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
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
                                      _buildInfoRow(Iconsax.calendar_add, _formatDate(task.taskStartDate), task.taskStartTime),
                                      SizedBox(height: TSizes.spaceBtwInputFields),
                                      _buildInfoRow(Iconsax.location, task.taskAddress, ""),
                                      SizedBox(height: 12),
                                      _buildInfoRow(Iconsax.user, "${task.client?.lastName} ${task.client?.name}", _controller.formatDate(task.client!.dateOfBirth)),
                                    ],
                                  )
                              ),
                              SizedBox(height: TSizes.spaceBtwSections),
                              Text('Волонтеры', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                              SizedBox(height: TSizes.spaceBtwItems),
                              _buildVolunteerList(task.volunteers)
                            ],
                          );
                        }
                        )
                    ),
                    SizedBox(height: TSizes.spaceBtwSections),
                    SwipeButton(
                      text: _controller.taskData.value?.taskStatus == 'В процессе' ? "Завершить заявку" : "Принять заявку",
                      onAccept: () {
                        if (_controller.taskData.value?.taskStatus == 'В процессе') {
                          _endTask();
                        } else {
                          acceptRequest();
                        }
                      },
                    ),

                    SizedBox(height: TSizes.spaceBtwSections),
                    StreamBuilder(
                      stream: _controller.messageStream,
                      builder: (context, snapshot) {
                        return Obx(() => _controller.lastMessage.isNotEmpty
                            ? Text(_controller.lastMessage.value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                            : SizedBox.shrink());
                      },
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

  Widget _buildVolunteerList(List<Volunteer>? volunteers) {
    print("volunteers list: $volunteers");

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
        return _volunteerCard(volunteers![index]);
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: TSizes.spaceBtwInputFields);
      },
    );
  }

  Widget _volunteerCard(Volunteer volunteer) {
    return Container(
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
      child: Row(
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
                  volunteer.name,
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
                  _controller.openPdfUrl(volunteer.dobroId!);
                },
              ),
              IconButton(
                icon: Icon(Iconsax.message, color: Colors.grey),
                onPressed: () {

                },
              ),
              IconButton(
                icon: Icon(Iconsax.call, color: Colors.grey),
                onPressed: () {
                  _controller.makePhoneCall(volunteer.phoneNumber);
                },
              ),
            ],
          ),
        ],
      ),
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

  Widget _buildInfoRow(IconData icon, String line1, String? line2) {
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

  void _endTask() {
    Get.dialog(AlertDialog(
      title: Text(
        "Подтвердите завершение",
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Для завершения заявки волонтер должен отсканировать QR-код.",
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
                data: 'fffff', // Данные QR-кода
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

  void acceptRequest() {

  }
}