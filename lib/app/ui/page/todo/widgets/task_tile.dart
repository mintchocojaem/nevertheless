import 'package:flutter/material.dart';

import '../../../../data/model/task.dart';



class TaskTile extends StatelessWidget {
  const TaskTile({Key? key, required this.task}) : super(key: key);
  final Task task;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).orientation == Orientation.portrait ?  MediaQuery.of(context).size.height *0.16:200,
      width: MediaQuery.of(context).orientation == Orientation.portrait ?  MediaQuery.of(context).size.width :MediaQuery.of(context).size.width *0.7,
      margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: MediaQuery.of(context).orientation == Orientation.portrait ? 10 : 0),
      decoration: BoxDecoration(
          color: Color(task.color!),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${task.title}',style: TextStyle(overflow: TextOverflow.ellipsis,),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(Icons.access_time_sharp,color: Colors.white,),
                    const SizedBox(
                      width: 15,
                    ),
                    Text('${task.startTime} - ${task.endTime}',style: TextStyle(color: Colors.white)),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(child: SingleChildScrollView(child: Text('${task.note}',style: TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,)))
              ],
            ),
          ),
        ],
      ),
    );
  }


}
