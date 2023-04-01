import 'package:flutter/material.dart';
import 'gui_storage.dart' as storageTab;
import 'gui_shopping-list.dart' as shoppingListTab;
import 'gui_recipe.dart' as recipeTab;

void main() => runApp(TenkiApp());

class TenkiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TENKI App',
      home: TenkiHomePage(),
    );
  }
}

class TenkiHomePage extends StatefulWidget {
  @override
  _TenkiHomePageState createState() => _TenkiHomePageState();
}

class _TenkiHomePageState extends State<TenkiHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: Text('TENKI - für deinen smarten Alltag'),
        backgroundColor: Colors.teal,
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.storage),
            ),
            Tab(
              icon: Icon(Icons.shopping_cart),
            ),
            Tab(
              icon: Icon(Icons.cookie),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [

                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        storageTab.VerticalTabBar(),
                        shoppingListTab.ShoppingList(),
                        recipeTab.recipe(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
