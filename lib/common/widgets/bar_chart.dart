import 'package:app/utils/constants/sizes.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/moderator/controllers/moderator_home_controller.dart';
import '../../utils/constants/colors.dart';

class BarChartSample1 extends StatefulWidget {
  BarChartSample1({super.key});

  final Color barBackgroundColor = TColors.green.withValues(alpha: 0.2);
  final Color barColor = TColors.green;
  final Color touchedBarColor = Color(0xFF2E7531);

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample1> {
  final Duration animDuration = const Duration(milliseconds: 250);
  final ModeratorHomeController _controller = Get.find();
  List<double> values = List.filled(7, 0);
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadChartData();
  }

  // В BarChartSample1State
  Future<void> _loadChartData() async {
    final weeklyData = await _controller.getWeeklyTasksCount();

    if (mounted) {
      setState(() {
        // Обновляем значения для каждого дня недели
        for (int i = 0; i < weeklyData.length; i++) {
          values[i] = weeklyData[i].toDouble();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'График заявок за неделю',
                style: TextStyle(
                  color: TColors.black,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: TSizes.spaceBtwItems),
              Expanded(
                child: Obx(() {
                  if (_controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return BarChart(
                    mainBarData(),
                    duration: animDuration,
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(
      int x,
      double y, {
        bool isTouched = false,
        Color? barColor,
        double width = 22,
        List<int> showTooltips = const [],
      }) {
    barColor ??= widget.barColor;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? widget.touchedBarColor : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Colors.grey)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: widget.barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(values.length, (i) {
    return makeGroupData(i, values[i], isTouched: i == touchedIndex);
  });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => Colors.blueGrey,
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;
            switch (group.x) {
              case 0:
                weekDay = 'Пн';
                break;
              case 1:
                weekDay = 'Вт';
                break;
              case 2:
                weekDay = 'Ср';
                break;
              case 3:
                weekDay = 'Чт';
                break;
              case 4:
                weekDay = 'Пт';
                break;
              case 5:
                weekDay = 'Сб';
                break;
              case 6:
                weekDay = 'Вс';
                break;
              default:
                throw Error();
            }
            return BarTooltipItem(
              '$weekDay\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY - 1).toString(),
                  style: const TextStyle(
                    color: Colors.white, //widget.touchedBarColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: const FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Пн', style: style);
        break;
      case 1:
        text = const Text('Вт', style: style);
        break;
      case 2:
        text = const Text('Ср', style: style);
        break;
      case 3:
        text = const Text('Чт', style: style);
        break;
      case 4:
        text = const Text('Пт', style: style);
        break;
      case 5:
        text = const Text('Сб', style: style);
        break;
      case 6:
        text = const Text('Вс', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      meta: meta,
      space: 16,
      child: text,
    );
  }
}