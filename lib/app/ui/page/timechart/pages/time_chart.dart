
import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nevertheless/app/ui/index_screen.dart';
import '../../../../data/model/task.dart';

class TimeChartPage extends StatefulWidget {
  TimeChartPage({Key? key, required this.taskList}) : super(key: key);
  @override
  State<TimeChartPage> createState() => _TimeChartPageState();
  List<Task?> taskList;

}

class _TimeChartPageState extends State<TimeChartPage> with TickerProviderStateMixin{

  List<Map> durationList = List.empty(growable: true);

  List<double> yList = List.empty(growable: true);

  List<Legend> legendList = List.empty(growable: true);

  List<BarChartRodData> addItem(int x, List<Map> list){

    List<BarChartRodData> result = List.empty(growable: true);
    double sumY = 0;

    for(Map i in list){

      for(DateTime j in i['duration']){

        if(j.weekday-1 == x){
          result.add(
              BarChartRodData(
                  fromY: sumY,
                  toY: ((j.hour * 60) + j.minute).toDouble() + sumY,
                  width: 8,
                  color: Color(i['color'])
              )
          );
          sumY += ((j.hour * 60) + j.minute).toDouble();

        }

      }
      yList.add(sumY);
    }
    return result;
  }

  BarChartGroupData generateGroupData(
      int x, List<Map> values) {
    return BarChartGroupData(
        x: x,
        groupVertically: true,
        barRods: addItem(x,values)
    );
  }

  Widget rightTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.white, fontSize: 10);
    String text;
    if (value == 0) {
      text = '0';
    } else {
      text = '${value.toInt()/60} hours';
    }
    return SideTitleWidget(
      angle: 0,
      axisSide: meta.axisSide,
      space: 0,
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }


  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xffffffff),
      fontSize: 10,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = "Mon";
        break;
      case 1:
        text = "Tue";
        break;
      case 2:
        text = "Wed";
        break;
      case 3:
        text = "Thr";
        break;
      case 4:
        text = "Fri";
        break;
      case 5:
        text = "Sat";
        break;
      case 6:
        text = "Sun";
        break;
      default:
        text = "";
    }
    return SideTitleWidget(
      child: Text(text, style: style),
      axisSide: meta.axisSide,
    );
  }

  @override
  Widget build(BuildContext context) {

    yList = List.empty(growable: true);
    durationList = List.empty(growable: true);
    legendList = List.empty(growable: true);

    for(Task? i in widget.taskList){

      Map<String,dynamic> durationMap = {
        'title' : "",
        'color' : 0,
        'duration' : [],
      };

      List<DateTime> timeLog = List.empty(growable: true);

      for(int j =0; j < i!.startTimeLog!.length; j++){
        timeLog.add(
          i.endTimeLog![j]!.subtract(Duration(hours: i.startTimeLog![j]!.hour,minutes: i.startTimeLog![j]!.minute ))
        );
      }
      durationMap['id'] = i.id;
      durationMap['title'] = i.title;
      durationMap['color'] = i.color;
      durationMap['duration'] = timeLog;

      durationList.add(durationMap);

      legendList.add(
        Legend(i.title!, Color(i.color!)),
      );
    }

    print(durationList);

    return Scaffold(
      appBar: AppBar(
        title: Text("Time Chart"),
      ),
      body: Center(
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Activity',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                LegendsListWidget(
                  legends: legendList
                ),
                const SizedBox(height: 14),
                AspectRatio(
                  aspectRatio: 1,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceBetween,
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 60,
                            getTitlesWidget: rightTitles,
                            reservedSize: 32
                          )
                        ),
                        topTitles: AxisTitles(),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: bottomTitles,
                          ),
                        ),
                      ),
                      barTouchData: BarTouchData(enabled: false),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: false),
                      barGroups: [
                        generateGroupData(0, durationList),
                        generateGroupData(1, durationList),
                        generateGroupData(2, durationList),
                        generateGroupData(3, durationList),
                        generateGroupData(4, durationList),
                        generateGroupData(5, durationList),
                        generateGroupData(6, durationList),
                      ],
                      maxY: (60 ~/ yList.reduce(max)) * 60,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

class LegendWidget extends StatelessWidget {
  final String name;
  final Color color;

  const LegendWidget({
    Key? key,
    required this.name,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          name,
          style: const TextStyle(
            color: Color(0xffffffff),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class LegendsListWidget extends StatelessWidget {
  final List<Legend> legends;

  const LegendsListWidget({
    Key? key,
    required this.legends,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      children: legends
          .map(
            (e) => LegendWidget(
          name: e.name,
          color: e.color,
        ),
      )
          .toList(),
    );
  }
}

class Legend {
  final String name;
  final Color color;

  Legend(this.name, this.color);
}

TimeOfDay stringToTimeOfDay(String tod) {
  final format = DateFormat.jm(); //"6:00 AM"
  return TimeOfDay.fromDateTime(format.parse(tod));
}

