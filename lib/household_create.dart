import 'package:flutter/material.dart';
import 'package:tenki/homepage.dart';
import 'package:tenki/login_register_page.dart';
import 'tenki_material/appbars.dart';
import 'tenki_material/tenki_colors.dart';
import 'firestore_interface.dart';


class HouseholdCreate extends StatelessWidget {

  final TextEditingController _controllerHouseholdName=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.loginAppBar('Haushalt erstellen', context),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Wie soll dein Haushalt heißen?',
                style: TextStyle(
                  color: TenkiColor5(),
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: _controllerHouseholdName,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Gib einen Namen für den Haushalt ein',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: TenkiColor4(),
                      ),
                    ),
                  ),
                  cursorColor: TenkiColor5(),
                  style: TextStyle(color: TenkiColor5()),
                  textAlign: TextAlign.center,
                ),
              ),


              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async {

                  DatabaseInterface dbInterface = DatabaseInterface();
                  await dbInterface.addHouseholdMap(_controllerHouseholdName.text);


                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => TenkiHomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TenkiColor1(),

                  minimumSize: const Size(250, 35),
                ),
                child: const Text('Erstellen'),

              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TenkiColor4(),
                  minimumSize: const Size(250, 35),
                ),
                child: const Text('Abbrechen'),
              ),
/// TO DO: abbrechen button
            ],
          ),
        ),
      ),
    );
  }
}
