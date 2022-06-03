import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pomodoro/app/controller/bottom_nav_controller.dart';
import 'package:pomodoro/app/ui/index_screen.dart';
import 'package:settings_ui/settings_ui.dart';


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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: SettingsList(
          sections: [
            _common(),
            _alarm(),
            _aboutApp(),
          ],
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        ),
        physics: ScrollPhysics(),
        controller: scrollController,
      ),
    );
  }

  SettingsSection _common() {
    return SettingsSection(
      title: Text('Common'),
      tiles: <SettingsTile>[
        SettingsTile.navigation(
          leading: Icon(Icons.account_box_outlined),
          title: Text('My Profile'),
          // value: Text('English'),
          onPressed: (context) {
            // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>@@@));
          },
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        SettingsTile.navigation(
          leading: Icon(Icons.language),
          title: Text('Language'),
          value: Text('English'),
          onPressed: (context) {
            // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>@@@));
          },
          trailing: Icon(Icons.arrow_forward_ios),
        ),
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
          leading: Icon(Icons.format_paint),
          title: Text('Dark Theme'),
        )
      ],
    );
  }

  SettingsSection _alarm() {
    return SettingsSection(
      title: Text('Alarm'),
      tiles: <SettingsTile>[
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
        // SettingsTile.switchTile(     // Alarm List 안에 넣을 예정
        //   onToggle: (value) {
        //     setState(() {
        //
        //     });
        //   },
        //   initialValue: true,
        //   leading: Icon(Icons.vibration),
        //   title: Text('Vibration Mode'),
        // ),
        SettingsTile.switchTile(
          onToggle: (value) {},
          initialValue: true,
          leading: Icon(Icons.add_alert_outlined),
          title: Text('Alarm On'),
        ),
      ],
    );
  }

  SettingsSection _aboutApp() {
    return SettingsSection(
      title: Text('About App'),
      tiles: <SettingsTile>[
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