import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nevertheless/ui/index_screen.dart';
import 'binding/init_bindings.dart';

void main() async{

  await GetStorage.init();
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
