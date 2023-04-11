import 'package:flutter/material.dart';
import 'package:tenki/widget_tree.dart';
import '../storage_tab.dart' as storage_tab;
import '../shopping-list_tab.dart' as shopping_list_tab;
import '../recipe_tab.dart' as recipe_tab;
import 'package:firebase_core/firebase_core.dart';
import 'logout_page.dart' as logout_page;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TenkiApp());
}

class TenkiApp extends StatelessWidget {
  const TenkiApp({Key?key}) :super(key: key);

  @override

  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'TENKI App',
        home: const WidgetTree()
    );
  }
}

class TenkiHomePage extends StatefulWidget {
  @override
  _TenkiHomePageState createState() => _TenkiHomePageState();
}

class _TenkiHomePageState extends State<TenkiHomePage>
    with SingleTickerProviderStateMixin {
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
        title: const Text('TENKI - für deinen smarten Alltag'),
              backgroundColor: Colors.teal,
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
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        const storage_tab.VerticalTabBar(),
                        const shopping_list_tab.ShoppingList(),
                        recipe_tab.Recipe(),
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