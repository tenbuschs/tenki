import 'package:flutter/material.dart';
import 'tenki_icons.dart';


class LocationIcons{

  static Widget getLocationItemById({int id=0, double size = 24, Color color = Colors.black}) {
    switch (id) {
      case 0:
        return TenkiIcons.add(size: size, color: color);
      case 1:
        return TenkiIcons.cow(size:size, color: color);
      default:
        return Container(child:Text("Invalid IconId"));
    }
  }



}