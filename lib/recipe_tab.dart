import 'package:flutter/material.dart';
import 'tenki_material/tenki_icons.dart';
import 'tenki_material/tenki_colors.dart';

class Recipe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Icon(Icons.menu_book, size: 150, color: TenkiColor1())
        //TenkiIcons.shoppingList(size:200, color: TenkiColor1()),
      ),
    );
  }
}



