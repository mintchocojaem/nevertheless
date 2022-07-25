import 'package:flutter/material.dart';
import '../../../data/todo.dart';


class TodoTile extends StatelessWidget {
  const TodoTile({Key? key, required this.todo}) : super(key: key);
  final Todo todo;

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      decoration: BoxDecoration(
          color: Color(todo.color!),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${todo.title}',style: const TextStyle(overflow: TextOverflow.ellipsis,),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.access_time_sharp,color: Colors.white,),
                    const SizedBox(
                      width: 15,
                    ),
                    Text('[${todoDays()}] ${todo.startTime} - ${todo.endTime}',style: const TextStyle(color: Colors.white)),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text('${todo.note}',style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,)
              ],
            ),
          ),
        ],
      ),
    );
  }

  String todoDays(){
    String dayText = "";
    int repeatCounter = 0;
    int addCounter = 0;

    for(bool i in todo.repeat!) {
      if(i) repeatCounter++;
    }

    for(int i = 0; i < todo.repeat!.length; i++){
      if(todo.repeat![i]){
        switch(i){
          case 0 :
            dayText += "월";
            addCounter++;
            if(addCounter < repeatCounter) dayText += ",";
            break;
          case 1 :
            dayText += "화";
            addCounter++;
            if(addCounter < repeatCounter) dayText += ",";
            break;
          case 2 :
            dayText += "수";
            addCounter++;
            if(addCounter < repeatCounter) dayText += ",";
            break;
          case 3 :
            dayText += "목";
            addCounter++;
            if(addCounter < repeatCounter) dayText += ",";
            break;
          case 4 :
            dayText += "금";
            addCounter++;
            if(addCounter < repeatCounter) dayText += ",";
            break;
          case 5 :
            dayText += "토";
            addCounter++;
            if(addCounter < repeatCounter) dayText += ",";
            break;
          case 6 :
            dayText += "일";
            addCounter++;
            if(addCounter < repeatCounter) dayText += ",";
            break;
        }
      }
    }
    return dayText;
  }
}
