import 'package:flutter/material.dart';
import 'package:tenki/tenki_material/tenki_colors.dart';
import 'tenki_material/appbars.dart';
import 'firestore_interface.dart';
import 'package:flutter/services.dart'; //copy to clipboard

class MyTenki extends StatefulWidget {
  const MyTenki({Key? key}) : super(key: key);

  @override
  State<MyTenki> createState() => _MyTenkiState();
}

class _MyTenkiState extends State<MyTenki> {
  String? householdId; // declare a variable to hold the household ID

  @override
  void initState() {
    super.initState();
    _loadData(); // call a function to load the household ID
  }

  Future<void> _loadData() async {
    DatabaseInterface dbInterface = DatabaseInterface();
    String? hid =
        await dbInterface.getHouseholdId(); // call the getHouseholdId function
    setState(() {
      householdId =
          hid; // update the householdId variable with the value returned by the function
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Code wurde in Zwischenablage kopiert')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.dropdownAppBar("Mein TENKI", context),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Text(
              "Einladungscode:",
              style: TextStyle(fontSize: 24),
            ),
            const Text(
              "(Lange drücken, um ihn der Zwischenablage zuzufügen):",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              child: Container(
                color: TenkiColor1(),
                padding: const EdgeInsets.all(10),
                child: Text(
                  householdId ?? 'Loading...',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              onLongPress: () {
                if (householdId != null) {
                  _copyToClipboard(householdId!);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
