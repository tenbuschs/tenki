import 'package:flutter/material.dart';
import 'tenki_material/tenki_icons.dart';
import 'tenki_material/tenki_colors.dart';

class Calender extends StatelessWidget {
  const Calender({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFFE2DCCE), Color(0xFFFFFFFF)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            tileMode: TileMode.clamp),
      ),
      padding: const EdgeInsets.all(10.0),
      //color: Colors.white,
      child: Center(
        child: TenkiIcons.calendar(size:150, color: TenkiColor1()),
      ),
    );
  }
}
