
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro/app/data/model/task.dart';
import 'package:pomodoro/app/ui/index_screen.dart';
import 'package:pomodoro/app/ui/page/timer/widgets/pomodoro_timer.dart';
import 'package:time_chart/time_chart.dart';

class TimeChartPage extends StatefulWidget {
  TimeChartPage({Key? key, required this.taskList}) : super(key: key);
  @override
  State<TimeChartPage> createState() => _TimeChartPageState();
  List<Task> taskList;

}

class _TimeChartPageState extends State<TimeChartPage> with TickerProviderStateMixin{


  @override
  Widget build(BuildContext context) {

    List<DateTimeRange> dataList = [];

    for(var i in taskList){
      if(i.startTimeLog != null){
        for(int j = 0; j < i.startTimeLog!.length; j++){
          final startFormat = i.startTimeLog![j]!;
          final endFormat = i.endTimeLog![j]!;
          setState((){
            dataList.add(
                DateTimeRange(
                    start: startFormat,
                    end: endFormat
                )
            );
          });
        }
      }
    }

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Time Chart'),
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
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TimeChart(
                    height: MediaQuery.of(context).size.height /2,
                    data: dataList,
                    chartType: ChartType.amount,
                    viewMode: ViewMode.weekly,
                    barColor: Colors.deepPurple,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: TimeChart(
                    height: MediaQuery.of(context).size.height /2,
                    data: dataList,
                    chartType: ChartType.amount,
                    viewMode: ViewMode.monthly,
                    barColor: Colors.deepPurple,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
TimeOfDay stringToTimeOfDay(String tod) {
  final format = DateFormat.jm(); //"6:00 AM"
  return TimeOfDay.fromDateTime(format.parse(tod));
}
