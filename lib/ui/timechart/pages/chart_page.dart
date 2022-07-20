import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/todo.dart';
import '../../index_page.dart';

class ChartPage extends StatefulWidget {

  const ChartPage({Key? key, required this.todoList}) : super(key: key);
  @override
  State<ChartPage> createState() => _ChartPageState();
  final List<Todo?> todoList;

}

class _ChartPageState extends State<ChartPage> with TickerProviderStateMixin{

  List<Map> durationList = List.empty(growable: true);
  List<double> yList = List.empty(growable: true);
  List<Legend> legendList = List.empty(growable: true);

  List<BarChartRodData> addItem(int x, List<Map> list){

    List<BarChartRodData> result = List.empty(growable: true);
    double sumY = 0;
    if(list.isNotEmpty){

      for(Map i in list){

        for(int j =0; j < 7; j++){

          if(j == x){
            result.add(
                BarChartRodData(
                    fromY: sumY,
                    toY: (i['duration'][j]).toDouble() + sumY,
                    width: 8,
                    color: Color(i['color'])
                )
            );
            sumY += (i['duration'][j]).toDouble();

          }
        }
      }
    }
    yList.add(sumY);

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
      text = '${value.toInt()~/60} hours';
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

    final storage = GetStorage();
    DateTime now = DateTime.now();
    bool init = storage.read('init') ?? false;
    if(now.weekday == 7 && !init){
      for(Todo i in todoList){
        i.timeLog = [0,0,0,0,0,0,0];
      }
      storage.write('init', true);
    }else if (now.weekday != 7){
      storage.write('init', false);
    }

    yList = List.empty(growable: true);

    durationList = List.empty(growable: true);
    legendList = List.empty(growable: true);

    for(Todo? i in widget.todoList){

      if(i?.timeLog != null){
        Map<String,dynamic> durationMap = {
          'title' : "",
          'color' : 0,
          'duration' : [],
        };

        List<int> timeLog = List.empty(growable: true);

        for(int j =0; j < i!.timeLog!.length; j++){
          timeLog.add(
              i.timeLog![j]!
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

    }


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Chart"),
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          '주별 기록 ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '(${now.weekday > 1 ? 8 - now.weekday: 7}일 후 갱신)',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(onPressed: (){
                      showCupertinoDialog(context: context, builder: (context) {
                        return CupertinoAlertDialog(
                          content: const Text(
                                  "1. 시간이 기록되려면 반드시 일정의 종료시각을 거쳐야합니다\n\n"
                                  "2. 일정 진행 중에 앱을 종료할 경우, 앱을 다시 시작한 시각으로부터 종료 시각까지의 시간을 계산합니다\n\n"
                                  "3. 일정 진행 중에 시작 시각을 앞당기더라도 기록에 반영되지 않습니다", textAlign: TextAlign.start,),
                          actions: [
                            CupertinoDialogAction(isDefaultAction: false, child: const Text("확인"), onPressed: () {
                              Navigator.pop(context);
                            })
                          ],
                        );
                      });
                      },
                        icon: const Icon(Icons.info_outline, size: 24,color: Colors.amber,))
                  ],
                ),
                const SizedBox(height: 8),
                LegendsListWidget(
                  legends: legendList
                ),
                const SizedBox(height: 14),
               Expanded(
                 child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                          ),
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
                        maxY: ((yList.reduce(max)~/60 * 60) +60).toDouble(),
                      ),
                    ),
               ),
              ],
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

