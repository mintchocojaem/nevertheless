import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:settings_ui/settings_ui.dart';

import '../../../../controller/bottom_nav_controller.dart';


class SettingPage extends GetView<BottomNavController> {
  SettingPage({Key? key}) : super(key: key);

  bool isDarkMode = false;

  late Box _darkMode;

  bool isSwitched = false;
  bool _vib = false;

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _darkMode = Hive.box('darkModeBox');
    isDarkMode = _darkMode.get('darkMode', defaultValue: true);
    return Scaffold(
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
    );
  }

  SettingsSection _settingSection() {
    return SettingsSection(
      tiles: <SettingsTile>[

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
        SettingsTile.navigation(
          leading: Icon(Icons.list),
          title: Text(
            'Alarm List',
            style: TextStyle(),
          ),
          onPressed: (context) {
            // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>@@@));
          },
          trailing: Icon(Icons.arrow_forward_ios),
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
