import 'package:flutter/material.dart';
import 'package:tenki/widget_tree.dart';
import '../storage_tab.dart' as storage_tab;
import '../shopping-list_tab.dart' as shopping_list_tab;
import '../recipe_tab.dart' as recipe_tab;
import 'package:firebase_core/firebase_core.dart';
import 'logout_page.dart' as logout_page;
import 'figma_to_code.dart' as figma;


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

