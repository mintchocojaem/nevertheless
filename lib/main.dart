import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro/app/binding/init_bindings.dart';
import 'package:pomodoro/app/ui/index_screen.dart';


void main() {

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
        home: IndexScreen(),
        // initialRoute: '/',
        routes: {
          // '/' : (context) => IndexScreen(),
          // '/todoListPage' : (context) => TaskPage(taskList: taskList),
          // '/settingPage' : (context) => SettingPage(),
        },
      )
  );
}
