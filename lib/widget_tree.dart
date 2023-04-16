import 'package:firebase_auth/firebase_auth.dart';
import 'package:tenki/logout_page.dart';
import 'package:tenki/login_register_page.dart';
import 'package:flutter/material.dart';
import 'package:tenki/auth.dart';
import 'package:tenki/main_page.dart';

class WidgetTree extends StatefulWidget{
  const WidgetTree({Key? key}): super(key:key);
  @override
  State<WidgetTree> createState() => _WidgetTreeState();

}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return TenkiMainPage();
        } else{
          return LoginPage();
        }
      },
    );
  }
}