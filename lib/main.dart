import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'app/binding/init_bindings.dart';
import 'app/data/model/task.dart';
import 'app/data/model/task_adapter.dart';
import 'app/ui/index_screen.dart';

const testBox = 'test';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter<Task>(TaskAdapter());

  await Hive.openBox(testBox);
  await Hive.openBox('darkModeBox');

  runApp(ValueListenableBuilder(
    builder: (context, Box box, widget) {
      final darkMode = box.get('darkMode', defaultValue: true);
      return GetMaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          /* light theme setting */
        ),
        darkTheme: darkMode
            ? ThemeData(
          brightness: Brightness.dark,
          /* dark theme setting */
        )
            : ThemeData(
          brightness: Brightness.light,
          /* dark theme setting */
        ),
        debugShowCheckedModeBanner: false,
        initialBinding: InitBinding(),
        themeMode: ThemeMode.dark,
        home: IndexScreen()
      );
    },
    valueListenable: Hive.box('darkModeBox').listenable(),
    // child: ,
  ));
}
