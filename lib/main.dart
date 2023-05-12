import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tenki/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyD9pHD6hlGebyM5t29HzAyPqGjxDn0cmL0",
        authDomain: "tenki-1d439.firebaseapp.com",
        projectId: "tenki-1d439",
        storageBucket: "tenki-1d439.appspot.com",
        messagingSenderId: "675339380935",
        appId: "1:675339380935:web:09b1fbaab331825d9476e2",
      )
    );
  }else{
    await Firebase.initializeApp();
  }


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
