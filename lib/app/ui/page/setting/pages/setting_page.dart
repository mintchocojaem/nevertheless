import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:settings_ui/settings_ui.dart';

import '../../../../controller/bottom_nav_controller.dart';

class SwitchX extends GetxController {
  RxBool on = false.obs; // our observable

  // swap true/false & save it to observable
  void toggle() => on.value = on.value ? false : true;
}

class SettingPage extends GetView<BottomNavController> {
  SettingPage({Key? key}) : super(key: key);

  final storage = GetStorage();   // instance of getStorage class
  SwitchX isNotification = Get.put(SwitchX());
  final ScrollController scrollController = ScrollController();
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  @override
  Widget build(BuildContext context) {

    isNotification.on.value = storage.read('notification') ?? true;

    return Obx(() => Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Settings"),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        controller: scrollController,
        child: SettingsList(
            sections: [
              _settingSection()
            ],
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
          ),
      ),
    ));
  }

  SettingsSection _settingSection() {
    return SettingsSection(
      tiles: <SettingsTile>[
        /*
        SettingsTile.switchTile(
          onToggle: (value) {
            if (value == true) {
              isDarkMode = true;
              _darkMode.put('darkMode', true);
            } else {
              isDarkMode = false;
              _darkMode.put('darkMode', false);
            }
          },
          initialValue: isDarkMode,
          leading: Icon(Icons.dark_mode),
          title: Text('Dark Theme'),
        ),

         */
        SettingsTile.switchTile(
          onToggle: (value) {

            if (value == true) {
              isNotification.toggle();
              storage.write('notification', true);
            } else {
              isNotification.toggle();
              print(false);
              storage.write('notification', false);
              flutterLocalNotificationsPlugin.cancelAll();
            }
          },
          initialValue: isNotification.on.value,
          leading: Icon(Icons.notifications),
          title: Text('Notification'),
        ),
        SettingsTile.navigation(
          leading: Icon(CupertinoIcons.rectangle_stack_person_crop),
          title: Text('About us'),
          onPressed: (context) {
            // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>@@@));
          },
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        SettingsTile.navigation(
          leading: Icon(CupertinoIcons.wrench),
          title: Text('Help'),
          onPressed: (context) {
            // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>@@@));
          },
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        SettingsTile.navigation(
          leading: Icon(Icons.account_balance_outlined),
          title: Text('License'),
          onPressed: (context) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => LicensePage()));
          },
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ],
    );
  }

}


