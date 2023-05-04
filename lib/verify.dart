import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tenki/main_page.dart';
import 'package:tenki/register_page.dart';
import 'package:tenki/household.dart';

class VerifyPage extends StatefulWidget {
  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    // Send verification email
    user?.sendEmailVerification();

    // Start timer to check email verification status
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verifizieren Sie Ihre E-Mail"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Es wurde eine E-Mail an ${user?.email} gesendet."),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text("Zurück zur Registrierung"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;

    await user!.reload();

    if (user!.emailVerified) {
      timer.cancel();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => RandomNumberGenerator()),
      );
    }
  }
}