import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nevertheless/ui/index_page.dart';
import 'binding/init_bindings.dart';
import 'firebase_options.dart';

void main() async{

  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  _initNotiSetting();

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

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
          home: const IndexScreen()
      )
  );
}

void _initNotiSetting() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const initSettingsAndroid = AndroidInitializationSettings('@drawable/ic_launcher');
  const initSettingsIOS = IOSInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );
  const initSettings = InitializationSettings(
    android: initSettingsAndroid,
    iOS: initSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
  );
}
