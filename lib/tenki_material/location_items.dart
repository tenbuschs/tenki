import 'package:flutter/material.dart';
import 'tenki_icons.dart';


List<Widget> locationIcons = [
  TenkiIcons.grain(),
  TenkiIcons.chili(),
  TenkiIcons.carot(),
  TenkiIcons.cookie(),
  TenkiIcons.cow(),
  TenkiIcons.grain(),
  TenkiIcons.chili(),
  TenkiIcons.carot(),
  TenkiIcons.cookie(),
  TenkiIcons.cow(),
  TenkiIcons.grain(),
  TenkiIcons.chili(),
  TenkiIcons.carot(),
  TenkiIcons.cookie(),
  TenkiIcons.cow(),
  TenkiIcons.thermometer(),
];

class LocationIcons{

  static Widget getLocationItemById({int id=0, double size = 24, Color color = Colors.black}) {
    switch (id) {
      case 0:
        return TenkiIcons.grain(size:size, color: color);
      case 1:
        return TenkiIcons.chili(size:size, color: color);
      case 2:
        return TenkiIcons.carot(size:size, color: color);
      case 3:
        return TenkiIcons.cookie(size:size, color: color);
      case 4:
        return TenkiIcons.cow(size:size, color: color);
      case 5:
        return TenkiIcons.grain(size:size, color: color);
      case 6:
        return TenkiIcons.chili(size:size, color: color);
      case 7:
        return TenkiIcons.carot(size:size, color: color);
      case 8:
        return TenkiIcons.cookie(size:size, color: color);
      case 9:
        return TenkiIcons.cow(size:size, color: color);
      case 10:
        return TenkiIcons.grain(size:size, color: color);
      case 11:
        return TenkiIcons.chili(size:size, color: color);
      case 12:
        return TenkiIcons.carot(size:size, color: color);
      case 13:
        return TenkiIcons.cookie(size:size, color: color);
      case 14:
        return TenkiIcons.cow(size:size, color: color);
      case 15:
        return TenkiIcons.thermometer(size:size, color: color);
      case 16:
        return TenkiIcons.add(size: size, color: color);
      default:
        return const Center(child:Text("Invalid IconId"));
    }
  }



}