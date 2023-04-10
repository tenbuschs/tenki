import 'package:firebase_auth/firebase_auth.dart';
import 'package:tenki/Pages/home_page.dart';
import 'package:tenki/pages/login_register_page.dart';
import 'package:flutter/material.dart';
import 'package:tenki/Pages/auth.dart';
//import 'package:tenki/Pages/login_register_page.dart';

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
          return HomePage();
        } else{
            return const LoginPage();
        }
      },
    );
  }
}