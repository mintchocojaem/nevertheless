import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


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

    await flutterLocalNotificationsPlugin.show(
        id,
        notiTitle,
        notiDesc,
        detail
    );

  }

}

