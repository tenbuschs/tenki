import 'package:flutter/material.dart';
import 'tenki_material/appbars.dart';
import 'firestore_interface.dart';
import 'tenki_material/tenki_colors.dart';

class Feedback extends StatefulWidget {
  const Feedback({Key? key}) : super(key: key);

  @override
  State<Feedback> createState() => _FeedbackState();
}

class _FeedbackState extends State<Feedback> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.dropdownAppBar("Feedback", context),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFE2DCCE), Color(0xFFFFFFFF)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              tileMode: TileMode.clamp),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: TenkiColor3(),
                border: Border.all(color: Colors.grey)
              ),
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: _textController,
                maxLines: 5,
                maxLength: 500,
                cursorColor: TenkiColor1(),
                decoration: InputDecoration(
                  hintText: 'Gebe hier deine Tipps, Hinweise, Verbesserungen, ... ein!',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: TenkiColor1(), width: 2),
                ),
              ),
            ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => onSubmit(),
              style: ElevatedButton.styleFrom(
                backgroundColor: TenkiColor1(),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Pontana Sans',
                  color: TenkiColor1(),
                ),
              ),
              child: const Text('Feedback übermitteln'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onSubmit() async {

    final text = _textController.text.trim();
    if (text.isEmpty) {
      // No feedback entered
      return;
    }

    await DatabaseInterface.addFeedback(
      text: text,
      dateTime: DateTime.now(),
    );

    _textController.clear();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Feedback erfolgreich übermittelt. Vielen Dank!'),
    ));
  }
}


