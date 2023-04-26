import 'package:flutter/material.dart';
import 'package:tenki/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TenkiApp());
}

class TenkiApp extends StatelessWidget {
  const TenkiApp({Key?key}) :super(key: key);

  @override

  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'TENKI App',
        home: const WidgetTree()
    );
  }
}