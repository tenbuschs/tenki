import 'package:flutter/material.dart';
import 'tenki_material/tenki_icons.dart';
import 'tenki_material/tenki_colors.dart';
import 'firestore_interface.dart';
import 'tenki_material/location_items.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFFE2DCCE), Color(0xFFFFFFFF)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            tileMode: TileMode.clamp),
      ),
      padding: const EdgeInsets.all(10.0),
      //color: Colors.white,
      child:
          Center(child: Icon(Icons.menu_book, size: 150, color: TenkiColor1())
              //TenkiIcons.shoppingList(size:200, color: TenkiColor1()),
              ),
    );
  }
}


