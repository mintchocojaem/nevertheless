import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/app_color.dart';


class MessagePopup extends StatelessWidget {
  final String? title;
  final String? message;
  final Function()? okCallback;
  final Function()? cancelCallback;

  MessagePopup({
    Key? key,
    required this.title,
    required this.message,
    required this.okCallback,
    this.cancelCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              width: Get.width*0.7,
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title!,
                        style: const TextStyle(
                           fontSize: 17, color: Colors.black),
                      ),
                    ),
                    Text(
                      message!,
                      style: TextStyle( color: Colors.grey[800]),
                    ),
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(7),),),
                            backgroundColor: MaterialStateProperty.all(app_green),
                            elevation: MaterialStateProperty.all(3),
                            side: MaterialStateProperty.all(BorderSide(width: 0.5,color:Colors.white)),
                          ),
                          onPressed:okCallback, child: Text('확인'),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(7),),),
                            backgroundColor: MaterialStateProperty.all(app_systemGrey4),
                            elevation: MaterialStateProperty.all(3),
                            side: MaterialStateProperty.all(BorderSide(width: 0.5,color:Colors.white)),
                          ),
                          onPressed: cancelCallback,
                          child: Text('취소',style: TextStyle(color: app_systemGrey1),),),
                      ],
                    )

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
