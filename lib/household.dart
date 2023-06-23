import 'package:TENKI/main_page.dart';
import 'tenki_material/tenki_colors.dart';
import 'package:flutter/material.dart';
import 'tenki_material/appbars.dart';
import 'package:TENKI/login_register_page.dart';
import 'household_create.dart';
import 'firestore_interface.dart';

class Household extends StatelessWidget {
  const Household({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Haushalt',
      home: RandomNumberGenerator(),
    );
  }
}

class RandomNumberGenerator extends StatefulWidget {
  const RandomNumberGenerator({Key? key}) : super(key: key);

  @override
  State<RandomNumberGenerator> createState() => _RandomNumberGeneratorState();
}

class _RandomNumberGeneratorState extends State<RandomNumberGenerator> {
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
                'Willkommen bei TENKI!\n\nMöchtest du einem bestehenden Haushalt beitreten oder einen neuen erstellen?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: TenkiColor5(),
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 30.0),
              Visibility(
                visible: _showErstellenButton,
                child: SizedBox(
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TenkiColor1(),
                    ),
                    child: const Text('Haushalt erstellen'),
                  ),
                ),
              ),
              const SizedBox(height: 7),
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
                      inputFormatters: const [
                        //FilteringTextInputFormatter.digitsOnly,
                        // LengthLimitingTextInputFormatter(5),
                      ], // Allow only numbers
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Bitte gib einen Haushaltscode ein';
                        }
                        if (int.tryParse(value) == null) {
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
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: ElevatedButton(
                    onPressed: () {
                      _toggleTextField();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TenkiColor1(),
                    ),
                    child: const Text('Haushalt beitreten'),
                  ),
                ),
              ),
              Visibility(
                visible: !_showErstellenButton,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ElevatedButton(
                    onPressed: () async {
                      DatabaseInterface dbInterface = DatabaseInterface();
                      if (await dbInterface
                              .doesHouseholdExist(_controller.text) ==
                          true) {
                        await dbInterface.joinHousehold(_controller.text);

                        householdId= await dbInterface.getHouseholdId();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TenkiMainPage(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Ungültiger Haushaltscode.',
                            ),
                            duration: Duration(seconds: 5),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TenkiColor1(),
                    ),
                    child: const Text('Beitreten'),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Visibility(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TenkiColor4(),
                    ),
                    child: const Text('Abbrechen'),
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
