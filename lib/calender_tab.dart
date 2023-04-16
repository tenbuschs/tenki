import 'package:flutter/material.dart';
import 'tenki_material/tenki_icons.dart';
import 'tenki_material/tenki_colors.dart';

class Calender extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: TenkiIcons.calendar(size:150, color: TenkiColor1()),
      ),
    );
  }
}
