import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'app/binding/init_bindings.dart';
import 'app/data/model/task.dart';
import 'app/data/model/task_adapter.dart';
import 'app/notification/notification.dart';
import 'app/ui/index_screen.dart';


void main() {

  WidgetsFlutterBinding.ensureInitialized();
  _initNotiSetting();

  runApp(
      GetMaterialApp(
          theme: ThemeData(
            brightness: Brightness.light,
            /* light theme setting */
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            /* dark theme setting */
          ),
          debugShowCheckedModeBanner: false,
          initialBinding: InitBinding(),
          themeMode: ThemeMode.dark,
          home: IndexScreen()
      )
  );
}
void _initNotiSetting() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  final initSettingsIOS = IOSInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );
  final initSettings = InitializationSettings(
    android: initSettingsAndroid,
    iOS: initSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
  );
}
