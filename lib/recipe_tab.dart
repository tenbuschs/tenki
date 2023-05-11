import 'package:flutter/material.dart';
import 'tenki_material/tenki_colors.dart';

class Recipe extends StatelessWidget {
  const Recipe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFFE2DCCE), Color(0xFFFFFFFF)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            tileMode: TileMode.clamp),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu_book, size: 150, color: TenkiColor1()),
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: const Text(
                    'Hier entsteht die TENKI Rezeptwelt - du kannst gespannt bleiben!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black87, letterSpacing: 1.2),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 5.0,
            right: 5.0,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: TenkiColor3(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      title: const Text('Wie funktioniert die TENKI Rezepte Ecke?'),
                      content: const Text(
                          "Es ist eigentlich ganz einfach:\nWir veröffentlichen jeden Tag in der Woche drei leckere Rezepte für euch. Außerdem gibt es immer drei wöchentlich wechselnde Rezepte, die ihr nachkochen könnt.\nMit dem kostenfreien Haushaltsaccount könnt ihr bis zu 25 Rezepte favorisieren - damit speichert ihr diese im Bereich Eigene Rezepte ab und könnt sie jederzeit aufrufen. nWenn ihr Rezepte schreibt und sie als öffentlich markiert kommen diesen in den Pool, aus dem wir täglich eines auswählen für die Community. Die anderen User werden dann euren Usernamen dort sehen und sich per click bei euch bedanken können."),
                      actions: [
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Verstanden',
                              style:
                              TextStyle(color: Colors.black87, letterSpacing: 1.5),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: TenkiColor1(),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 8.0),
                              elevation: 3.0,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.black87,
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                side: const BorderSide(width: 1.0, color: Colors.black87),
                elevation: 3.0,
                backgroundColor: TenkiColor3(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
