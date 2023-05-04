import 'dart:math';
import 'tenki_material/tenki_colors.dart';
import 'package:flutter/material.dart';
import 'package:tenki/register_page.dart';
import 'tenki_material/appbars.dart';
import 'package:tenki/login_register_page.dart';
import 'household_create.dart';
import 'package:flutter/services.dart';



class Household extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Haushalt',
      home: RandomNumberGenerator(),
    );
  }
}

class RandomNumberGenerator extends StatefulWidget {
  @override
  _RandomNumberGeneratorState createState() => _RandomNumberGeneratorState();
}

class _RandomNumberGeneratorState extends State<RandomNumberGenerator> {
  int _household = 0;
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  bool _showErstellenButton = true;
  bool _showBeitretenTextField = false;


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleTextField() {
    setState(() {
      _showErstellenButton = false;
      _showBeitretenTextField = true;
    });
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.loginAppBar('Haushalt', context),
      body: Container(
        decoration: BoxDecoration(
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
                'Willkommen bei TENKI!\n\nMöchtest du einem bestehenden Haushalt beitreten oder einen neuen erstellen?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: TenkiColor5(),
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 30.0),
              Visibility(
                visible: _showErstellenButton,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HouseholdCreate(),
                        ),
                      );
                    },
                    child: Text('Haushalt erstellen'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TenkiColor1(),

                    ),
                  ),
                ),
              ),

              SizedBox(height: 7),
              Visibility(
                visible: _showBeitretenTextField,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'Haushaltscode',
                        labelStyle: TextStyle(color: TenkiColor1()),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: TenkiColor1(),
                          ),
                        ),
                      ),
                      cursorColor: TenkiColor4(),
                      style: TextStyle(color: TenkiColor5()), // Set text color
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(5),
                      ], // Allow only numbers
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Bitte gib einen Haushaltscode ein';
                        }
                        if (value?.length != 5) {
                          return 'Ein Haushaltscode muss 5 Stellen haben!';
                        }
                        if (int.tryParse(value!) == null) {
                          return 'Bitte gib einen gültigen Code ein';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: _showErstellenButton,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: ElevatedButton(
                    onPressed: () {
                      _toggleTextField();
                    },
                    child: Text('Haushalt beitreten'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TenkiColor1(),)
                  ),
                ),
              ),

              Visibility(
                visible: !_showErstellenButton,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      }
                    },
                    child: Text('Beitreten'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TenkiColor1(),
                    )
                  ),
                ),
              ),
              SizedBox(height: 5),

              Visibility(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ElevatedButton(
                    onPressed: () {Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                    },
                    child: Text('Abbrechen'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TenkiColor4(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
