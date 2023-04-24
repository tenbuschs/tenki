import 'package:flutter/material.dart';

import 'storage_tab.dart' as storage_tab;
import 'shopping-list_tab.dart' as shopping_list_tab;
import 'recipe_tab.dart' as recipe_tab;
import 'calender_tab.dart' as calender_tab;

import 'tenki_material/tenki_icons.dart';
import 'tenki_material/tenki_colors.dart';
import 'tenki_material/appbars.dart';


class TenkiHomePage extends StatefulWidget {
  @override
  _TenkiHomePageState createState() => _TenkiHomePageState();
}

class _TenkiHomePageState extends State<TenkiHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;



  @override
  Widget build(BuildContext context) {
    final double remainingHeight = MediaQuery.of(context).size.height - 200.0;

    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'für deinen smarten Alltag',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: TenkiColor5(),
                    ),
                  ),
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  storage_tab.build(), // Use TwoColumnLocationView widget
                            ),);
                        },
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            'Vorrat',
                            textAlign: TextAlign.center,
                            style: TextStyle(
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
                                builder: (context) => recipe_tab.Recipe()),
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
                                    shopping_list_tab.ShoppingList()),
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
                                builder: (context) => calender_tab.Calender()),
                          );
                        },
                        child: Text(
                          'Planer',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            color: TenkiColor5(),
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