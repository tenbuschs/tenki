import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tenki/auth.dart';
import 'package:tenki/verify.dart';
import 'firestore_interface.dart';
import 'tenki_material/tenki_colors.dart';
import 'register_page.dart';
import 'homepage.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Passwort zurücksetzen',
        style: TextStyle(
          color: TenkiColor5(),
        ),
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Bitte gib hier deine E-Mail-Adresse ein.';
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: 'E-Mail-Adresse',
            labelStyle: TextStyle(
              color: TenkiColor1(),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: TenkiColor1(),
              ),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Abbrechen',
            style: TextStyle(
              color: TenkiColor5(),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text(
            'Link senden',
            style: TextStyle(
              color: TenkiColor5(),
            ),
          ),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              try {
                await FirebaseAuth.instance.sendPasswordResetEmail(
                  email: _emailController.text,
                );
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Eine E-Mail zum Zurücksetzen des Passworts wurde an ${_emailController.text} gesendet.',
                    ),
                    duration: Duration(seconds: 5),
                  ),
                );
              } on FirebaseAuthException catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Bitte gib eine gültige E-Mail Adresse an!',
                    ),
                    duration: Duration(seconds: 5),
                  ),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            primary: TenkiColor1(),
          ),
        ),
      ],
    );
  }
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      if (userCredential.user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => VerifyPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      // Create database interface instance
      DatabaseInterface dbInterface = DatabaseInterface();
      // Add example data map for current user
      await dbInterface.addExampleDataMap();
      await dbInterface.addExampleLocationMap();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => TenkiHomePage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _loginButton() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: ElevatedButton(
        onPressed: signInWithEmailAndPassword,
        child: Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: TenkiColor1(),
          minimumSize: Size(double.infinity, 35),
        ),
      ),
    );
  }



  Widget _title() {
    return Text(
      'TENKI Login',
      style: TextStyle(
        color: TenkiColor5(),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _entryField(String title, TextEditingController controller,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: title,
          labelStyle: TextStyle(color: TenkiColor1()),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: TenkiColor1(),
            ),
          ),
        ),
        cursorColor: TenkiColor4(),
        obscureText: isPassword,
      ),
    );
  }

  Widget _errormessage() {
    return Text(
        errorMessage == '' ? '' : 'Bitte E-Mail und Passwort eingeben!');
  }

  Widget _loginText() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        'Bitte log dich mit deinen TENKI Daten ein. \n\nWenn du neu bei TENKI bist klick einfach auf Registrieren.\n',
        style: TextStyle(
          color: TenkiColor5(),
          fontSize: 16,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: ElevatedButton(
        onPressed: isLogin
            ? signInWithEmailAndPassword
            : createUserWithEmailAndPassword,
        child: Text(
          isLogin ? 'Login' : 'Registrieren',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: TenkiColor1(),
          minimumSize: Size(double.infinity, 35),
        ),
      ),
    );
  }

  Widget _registerButton() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterPage()),
          );
        },
        child: Text(
          'Registrieren',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: TenkiColor2(),
          minimumSize: Size(double.infinity, 35),
        ),
      ),
    );
  }

  Widget _loginOrRegisterButton() {
    return isLogin ? _registerButton() : _loginButton();
  }


  @override

  Widget _forgotPasswordButton() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ForgotPasswordDialog();
            },
          );
        },
        child: Text(
          'Passwort vergessen',
          style: TextStyle(
            color: TenkiColor1(),
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          minimumSize: Size(double.infinity, 35),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
        backgroundColor: TenkiColor1(),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE2DCCE), Color(0xFFFFFFFF)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              tileMode: TileMode.clamp,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _loginText(),
                _entryField('E-Mail', _controllerEmail),
                _entryField('Passwort', _controllerPassword, isPassword: true),
                _errormessage(),
                _submitButton(),
                _loginOrRegisterButton(),
                _forgotPasswordButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

