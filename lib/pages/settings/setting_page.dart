import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isSwitched = false;
  bool _vib = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SettingsList(
        sections: [
          _common(),
          _alarm(),
          _aboutApp(),
        ],
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
          onToggle: (value) {},
          initialValue: true,
          leading: Icon(Icons.format_paint),
          title: Text('Dark theme'),
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
          title: Text('Alarm List',style: TextStyle(),),
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
            // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>@@@));
          },
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ],
    );
  }
}
