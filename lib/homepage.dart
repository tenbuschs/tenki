import 'package:flutter/material.dart';
import 'main_page.dart' as main_page;
import 'tenki_material/tenki_colors.dart';
import 'firestore_interface.dart';
import 'dart:async';

class TenkiHomePage extends StatefulWidget {
  @override
  _TenkiHomePageState createState() => _TenkiHomePageState();
}

class _TenkiHomePageState extends State<TenkiHomePage> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    startScrollTimer();
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void startScrollTimer() {
    _scrollTimer = Timer(const Duration(seconds: 5), () {
      _scrollToBottom();
    });
  }

  void resetScrollTimer() {
    _scrollTimer?.cancel();
    startScrollTimer();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
    resetScrollTimer();
  }

  @override
  Widget build(BuildContext context) {
    final double remainingHeight = MediaQuery.of(context).size.height - 300.0;

    return Scaffold(
      backgroundColor: TenkiColor1(),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _scrollToBottom,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height-250,
                    color:TenkiColor1(),
                    alignment: Alignment.center,
                    ),
                  Container(
                    height: 200,
                    color: TenkiColor1(),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'TENKI',
                          style: TextStyle(
                            fontSize: 72,
                            color: TenkiColor5(),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'für deinen smarten Alltag',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: TenkiColor5(),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(height:50, color: TenkiColor1(), alignment: Alignment.center),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: TenkiColor5(),
                    width: 1,
                  ),
                ),
              ),
            ),
            Container(
              color: TenkiColor2(),
              height: remainingHeight,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: TenkiColor5(),
                            width: 1,
                          ),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          DatabaseInterface dbInterface = DatabaseInterface();
                          householdId= await dbInterface.getHouseholdId();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const main_page.TenkiMainPage(initialIndex: 0,), // Use TwoColumnLocationView widget
                            ),);
                        },
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            'Vorrat',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 24,
                              color: TenkiColor5(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: TenkiColor5(),
                          ),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const main_page.TenkiMainPage(initialIndex: 1)),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            'Rezepte',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              color: TenkiColor5(),
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: TenkiColor5(),
                          ),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const main_page.TenkiMainPage(initialIndex: 2)),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            'Einkaufsliste',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              color: TenkiColor5(),
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: TenkiColor5(),
                          ),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const main_page.TenkiMainPage(initialIndex: 3)),
                          );
                        },
                        child: Text(
                          'Planer',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            color: TenkiColor5(),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}