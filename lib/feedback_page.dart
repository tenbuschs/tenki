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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textController,
              maxLines: 5,
              maxLength: 500,
              decoration: const InputDecoration(
                hintText: 'Gebe hier deine Tipps, Hinweise, Verbesserungen, ... ein!',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => onSubmit(),
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


