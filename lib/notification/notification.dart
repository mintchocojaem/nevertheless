
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future taskNotification(int id, String notiTitle, String notiDesc) async {


  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final result = await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
    alert: true,
    badge: true,
    sound: true,
  );

  var android = AndroidNotificationDetails("channel", notiTitle,channelDescription:  notiDesc,
      importance: Importance.max, priority: Priority.max);
  var ios = IOSNotificationDetails();
  var detail = NotificationDetails(android: android, iOS: ios);

  if (result != null && result) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannelGroup("channel");

    await flutterLocalNotificationsPlugin.zonedSchedule(
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
