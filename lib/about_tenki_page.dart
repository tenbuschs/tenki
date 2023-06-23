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
      appBar: AppBars.dropdownAppBar("über TENKI", context),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE2DCCE), Color(0xFFFFFFFF)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  const Text(
                    "Was steckt hinter TENKI?",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: const Text(
                      "Wir, das sind Simon Tenbusch, Julian Kirch und Pascal Klein Helmkamp. \nIn unserem Umfeld haben wir immer wieder Rufe nach einem gut gelösten, smarten Vorratsmanagement gehört - nun und das haben wir uns zum Projekt gemacht. So ist TENKI entstanden, wir haben einfach nur Vorratsmanagement weiter gedacht: \n\nDie Implementierung von Rezepten und einem (Wochen-)Planer - in Verbindung mit deinem Vorrat und deiner Einkaufsplanung macht TENKI so besonders.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
