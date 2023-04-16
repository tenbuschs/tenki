import 'package:flutter/material.dart';

import '../storage_tab.dart' as storage_tab;
import '../shopping-list_tab.dart' as shopping_list_tab;
import '../recipe_tab.dart' as recipe_tab;
import 'calender_tab.dart' as calender_tab;
import 'logout_page.dart' as logout_page;



import 'tenki_material/tenki_icons.dart';
import 'tenki_material/tenki_colors.dart';



class TenkiMainPage extends StatefulWidget {
  @override
  _TenkiMainPageState createState() => _TenkiMainPageState();
}

class _TenkiMainPageState extends State<TenkiMainPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TenkiIcons.tenki(size: 40),
        title: Text('TENKI - für deinen smarten Alltag', style: TextStyle(
          color: Colors.black,
        ),),
        backgroundColor: TenkiColor2(),
        actions: [
          PopupMenuButton(
            // add icon, by default "3 dot" icon
            // icon: Icon(Icons.book)
              itemBuilder: (context){
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("My Account"),
                  ),

                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text("Settings"),
                  ),

                  const PopupMenuItem<int>(
                    value: 2,
                    child: Text("Logout"),
                  ),
                ];
              },
              onSelected:(value){
                if(value == 0){
                  print("My account menu is selected.");
                }else if(value == 1){
                  print("Settings menu is selected.");
                }else if(value == 2){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => logout_page.LogoutPage()),
                  );
                }
              }
          ),
        ],

      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // storage_tab
                        const storage_tab.VerticalTabBar(),
                        //recipe_tab
                        recipe_tab.Recipe(),
                        // shopping-list_tab
                        const shopping_list_tab.ShoppingList(),
                        // calender_tab
                        calender_tab.Calender(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 100,
        color: TenkiColor4(),
        child: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Container(
              child: TenkiIcons.storage(size: 50),
            ),
            Container(
              child: Icon(Icons.menu_book, size: 50, color: Colors.black),
            ),
            Container(
              child: TenkiIcons.shopping_bag(size: 50),
            ),
            Container(
              child: TenkiIcons.calendar(size: 50),
            ),
          ],
          indicator: BoxDecoration(
            color: TenkiColor2(),
            border: Border(
              bottom: BorderSide(
                color: TenkiColor5(),
                width: 2.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}



