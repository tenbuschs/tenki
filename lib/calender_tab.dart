import 'package:flutter/material.dart';
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_month_outlined,  size:150, color: TenkiColor1()),
          const SizedBox(height: 20.0),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: const Text(
              'Hier kannst du bald deine Woche mit TENKI planen!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black87, letterSpacing: 1.2),
            ),
          ),
        ],
      ),
    );
  }
}
