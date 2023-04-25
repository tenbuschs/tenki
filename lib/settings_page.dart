import 'package:flutter/material.dart';
import 'tenki_material/appbars.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBars.dropdownAppBar("Einstellungen", context),
        body: const Center(child: Text("Hier bald die Einstellungen..."))
    );



  }
}