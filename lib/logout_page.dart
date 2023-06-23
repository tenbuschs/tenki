import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:TENKI/auth.dart';
import 'tenki_material/appbars.dart';
import 'tenki_material/tenki_colors.dart';
import 'login_register_page.dart';

class LogoutPage extends StatelessWidget {
  LogoutPage({Key? key}) : super(key: key);
  final User? user = Auth().currentUser;

  Future<void> signOut(BuildContext context) async {
    await Auth().signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
    );

  }



  Widget _confirmationMessage() {
    return Text(
      'Möchtest du dich mit der E-Mail: \n${user?.email} \nabmelden?',
      style: const TextStyle(fontSize: 20, fontFamily: 'Pontana Sans'),
      textAlign: TextAlign.center,
    );
  }

  Widget _signOutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => signOut(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: TenkiColor2(),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: TextStyle(
          fontSize: 20,
            fontFamily: 'Pontana Sans',
          color: TenkiColor1(),
        ),
      ),
      child: const Text('Log Out'),
    );
  }

  Widget _abortButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.of(context).pop(),
      style: ElevatedButton.styleFrom(
        backgroundColor: TenkiColor4(),
        side: BorderSide(color: TenkiColor4()),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: TextStyle(
          fontFamily: 'Pontana Sans',
          color: TenkiColor5(),
          fontSize: 20,
        ),
      ),
      child: const Text('Abbrechen'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.dropdownAppBar("Logout", context),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE2DCCE), Color(0xFFFFFFFF)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            tileMode: TileMode.clamp,
          ),
        ),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _confirmationMessage(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _signOutButton(context),
                  _abortButton(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}