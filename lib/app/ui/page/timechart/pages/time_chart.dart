
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro/app/data/model/task.dart';
import 'package:pomodoro/app/ui/page/timer/widgets/pomodoro_timer.dart';
import 'package:time_chart/time_chart.dart';

class TimeChartPage extends StatefulWidget {
  const TimeChartPage({Key? key}) : super(key: key);
  @override
  State<TimeChartPage> createState() => _TimeChartPageState();
}

class _TimeChartPageState extends State<TimeChartPage> with TickerProviderStateMixin{

  final smallDataList = [
    DateTimeRange(
      start: DateTime(2021, 2, 24, 23, 15),
      end: DateTime(2021, 2, 25, 7, 30),
    ),
    DateTimeRange(
      start: DateTime(2021, 2, 22, 1, 55),
      end: DateTime(2021, 2, 22, 9, 12),
    ),
    DateTimeRange(
      start: DateTime(2021, 2, 20, 0, 25),
      end: DateTime(2021, 2, 20, 7, 34),
    ),
    DateTimeRange(
      start: DateTime(2021, 2, 17, 21, 23),
      end: DateTime(2021, 2, 18, 4, 52),
    ),
    DateTimeRange(
      start: DateTime(2021, 2, 13, 6, 32),
      end: DateTime(2021, 2, 13, 13, 12),
    ),
    DateTimeRange(
      start: DateTime(2021, 2, 1, 9, 32),
      end: DateTime(2021, 2, 1, 15, 22),
    ),
    DateTimeRange(
      start: DateTime(2021, 1, 22, 12, 10),
      end: DateTime(2021, 1, 22, 16, 20),
    ),
  ];

  List<DateTimeRange> getRandomSampleDataList() {
    final List<DateTimeRange> list = [];
    final random = Random();

    for (int i = 0; i < 10000; ++i) {
      final int randomMinutes1 = random.nextInt(59);
      final int randomMinutes2 = random.nextInt(59);
      final start = DateTime(2021, 2, 1 - i, 0, randomMinutes1);
      final end = DateTime(2021, 2, 1 - i, 7, randomMinutes2 + randomMinutes1);

      list.add(DateTimeRange(
        start: start,
        end: end,
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Tabs Demo'),
            // TabBar 구현. 각 컨텐트를 호출할 탭들을 등록
            bottom: TabBar(
              tabs: [
                Tab(text: "Weekly",),
                Tab(text: "Monthly",),
              ],
            ),
          ),
          // TabVarView 구현. 각 탭에 해당하는 컨텐트 구성
          body: TabBarView(
            children: [
              TimeChart(
                data: smallDataList,
                chartType: ChartType.amount,
                viewMode: ViewMode.weekly,
                barColor: Colors.deepPurple,
              ),
              TimeChart(
                data: smallDataList,
                chartType: ChartType.amount,
                viewMode: ViewMode.monthly,
                barColor: Colors.deepPurple,
              ),
            ],
          ),
        ),
      ),
    );
  }

}
