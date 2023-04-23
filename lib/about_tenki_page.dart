import 'package:flutter/material.dart';
import 'tenki_material/appbars.dart';

class AboutTenki extends StatefulWidget {
  const AboutTenki({Key? key}) : super(key: key);

  @override
  State<AboutTenki> createState() => _AboutTenkiState();
}

class _AboutTenkiState extends State<AboutTenki> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBars.dropdownAppBar("About TENKI", context),
        body: const Center(child: Text("Hier bald Infos über TENKI..."))
    );



  }
}