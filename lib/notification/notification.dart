import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future todoNotification(int id, String notiTitle, String notiDesc) async {


  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final result = await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(alert: true, badge: true, sound: true,);

  var android = AndroidNotificationDetails("nevertheless", notiTitle,channelDescription:  notiDesc,
      importance: Importance.max, priority: Priority.max, playSound: true);
  var ios = const IOSNotificationDetails();
  var detail = NotificationDetails(android: android, iOS: ios);

  if ((!Platform.isAndroid && result != null && result) || Platform.isAndroid) {

    if(Platform.isAndroid){
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.deleteNotificationChannelGroup("nevertheless");
    }

    /*await flutterLocalNotificationsPlugin.zonedSchedule(
      id, // id는 unique해야합니다. int값
      notiTitle,
      notiDesc,
      _setNotiTime(),
      detail,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

     */

    await flutterLocalNotificationsPlugin.show(
        id,
        notiTitle,
        notiDesc,
        detail
    );

  }

}

tz.TZDateTime _setNotiTime() {

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

  final now = tz.TZDateTime.now(tz.local);
  var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
      now.hour, now.minute, now.second);

  return scheduledDate;
}
