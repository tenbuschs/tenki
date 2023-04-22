import 'package:flutter/material.dart';
import 'tenki_material/appbars.dart';

class Feedback extends StatefulWidget {
  const Feedback({Key? key}) : super(key: key);

  @override
  State<Feedback> createState() => _FeedbackState();
}

class _FeedbackState extends State<Feedback> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBars.dropdownAppBar("Feedback", context),
        body: const Center(child: Text("Hier kannst du bald Feedback hinterlassen..."))
    );



  }
}