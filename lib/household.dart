import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:tenki/main_page.dart';

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
  int _household = -1;
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  void _generateRandomNumber() {
    Random random = new Random();
    int min = 10000;
    int max = 99999;
    int randomNumber = min + random.nextInt(max - min);
    setState(() {
      _household = randomNumber;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Haushalt'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Gib eine fünfstellige Haushaltsnummer ein!',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Bitte gib eine Haushaltsnummer ein';
                    }
                    if (value?.length != 5) {
                      return 'Eine Haushaltsnummer muss 5 Stellen haben!';
                    }
                    if (int.tryParse(value!) == null) {
                      return 'Bitte gib eine gültige Nummer ein';
                    }
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text("Haushalt beigetreten!"),
                    content: Text("Sie können sich jetzt einloggen."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => TenkiMainPage()),
                          );
                        },
                        child: Text("OK"),
                      ),
                    ],
                  ),
                );
              },
              child: Text("Haushalt beitreten"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _generateRandomNumber();
                }
              },
              child: Text('Haushalt erstellen'),
            ),
            SizedBox(height: 16),
            Text(
              'Haushalt:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '$_household',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}