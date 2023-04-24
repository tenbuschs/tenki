import 'package:flutter/material.dart';
import 'tenki_icons.dart';


List<Widget> locationIcons = [
  TenkiIcons.frosty(),
  TenkiIcons.thermometer(),
  TenkiIcons.door(),
  TenkiIcons.spider(),
  TenkiIcons.igloo(),
  TenkiIcons.medical(),
  TenkiIcons.house(),
  TenkiIcons.factory(),
  TenkiIcons.dungeon(),
  TenkiIcons.bin(),
  TenkiIcons.couch(),
  TenkiIcons.box(),
  TenkiIcons.box_open(),
  TenkiIcons.biohazard(),
  TenkiIcons.archive(),
  TenkiIcons.chesss_rook(),
];

class LocationIcons{

  static Widget getLocationItemById({int id=0, double size = 24, Color color = Colors.black}) {
    switch (id) {
      case 0:
        return TenkiIcons.frosty(size:size, color: color);
      case 1:
        return TenkiIcons.thermometer(size:size, color: color);
      case 2:
        return TenkiIcons.door(size:size, color: color);
      case 3:
        return TenkiIcons.spider(size:size, color: color);
      case 4:
        return TenkiIcons.igloo(size:size, color: color);
      case 5:
        return TenkiIcons.medical(size:size, color: color);
      case 6:
        return TenkiIcons.house(size:size, color: color);
      case 7:
        return TenkiIcons.factory(size:size, color: color);
      case 8:
        return TenkiIcons.dungeon(size:size, color: color);
      case 9:
        return TenkiIcons.bin(size:size, color: color);
      case 10:
        return TenkiIcons.couch(size:size, color: color);
      case 11:
        return TenkiIcons.box(size:size, color: color);
      case 12:
        return TenkiIcons.box_open(size:size, color: color);
      case 13:
        return TenkiIcons.biohazard(size:size, color: color);
      case 14:
        return TenkiIcons.archive(size:size, color: color);
      case 15:
        return TenkiIcons.chesss_rook(size:size, color: color);
      case 16:
        return TenkiIcons.add(size: size, color: color);
      default:
        return const Center(child:Text("Invalid IconId"));
    }
  }



}