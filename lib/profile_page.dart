import 'package:flutter/material.dart';
import 'tenki_material/appbars.dart';

class MyTenki extends StatefulWidget {
  const MyTenki({Key? key}) : super(key: key);

  @override
  State<MyTenki> createState() => _MyTenkiState();
}

class _MyTenkiState extends State<MyTenki> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBars.dropdownAppBar("Mein TENKI", context),
      body: const Center(child: Text("Hier bald den Profil..."))
    );



  }
}


