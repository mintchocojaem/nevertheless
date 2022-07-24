import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future todoNotification(int id, String notiTitle, String notiDesc, int duration) async {


  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final result = await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(alert: true, badge: true, sound: true,);

    var android = const AndroidNotificationDetails("nevertheless", "nevertheless",
      importance: Importance.max, priority: Priority.high, playSound: true);
  var ios = const IOSNotificationDetails();
  var detail = NotificationDetails(android: android, iOS: ios);

  if ((!Platform.isAndroid && result != null && result) || Platform.isAndroid) {

    tz.initializeTimeZones();
    String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));

    final storage = GetStorage();
    bool isNotification = storage.read('notification') ?? true;

    if(isNotification){
      await flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          notiTitle,
          notiDesc,
          tz.TZDateTime.now(tz.local).add(Duration(seconds: duration)),
          detail,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime
      );
    }

  }

}

