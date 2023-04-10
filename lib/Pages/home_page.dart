import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_auth_project/auth.dart';
import 'package:flutter/material.dart';
import 'package:tenki/Pages/auth.dart';

class HomePage extends StatelessWidget{
  HomePage({Key? key}) : super(key: key);

  final User? user =Auth().currentUser;

  Future<void> signOut()async{
    await Auth().signOut();
  }
  Widget _title(){
    return const Text('Firebase Auth' );
  }
  Widget _userUid(){
    return Text(user?.email ?? 'Ueser email');
  }
  Widget _signOutButton(){
    return ElevatedButton(
        onPressed: signOut,
         child: const Text('Sign Out')
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _userUid(),
            _signOutButton(),
          ],
        ),
      ),
    );
  }
}