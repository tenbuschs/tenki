import 'package:flutter/material.dart';

//Beispieldaten Lagerbestand
Map<String, dynamic> storageMap = {
  "items": [
    {
      "name": "Spinat TK",
      "location": "Tiefkühltruhe",
      "unit": "Beutel á 1 kg",
      "targetQuantity": 1,
      "stockQuantity": 0,
      "buyQuantity": 1,
    },
    {
      "name": "Fischstäbchen",
      "location": "Tiefkühltruhe",
      "unit": "Packung a 18 Stück",
      "targetQuantity": 2,
      "stockQuantity": 2,
      "buyQuantity": 0,
    },
    {
      "name": "Notfallpizza",
      "location": "Tiefkühltruhe",
      "unit": "Stück",
      "targetQuantity": 3,
      "stockQuantity": 2,
      "buyQuantity": 1,
    },
    {
      "name": "Kartoffeln",
      "location": "Keller",
      "unit": "Säcke á 2,5kg",
      "targetQuantity": 2,
      "stockQuantity": 0,
      "buyQuantity": 2,
    },
    {
      "name": "Zwiebeln",
      "location": "Keller",
      "unit": "kg",
      "targetQuantity": 1,
      "stockQuantity": 0,
      "buyQuantity": 1,
    },
    {
      "name": "Karotten",
      "location": "Keller",
      "unit": "kg",
      "targetQuantity": 1,
      "stockQuantity": 0.5,
      "buyQuantity": 0.5,
    },
    {
      "name": "Eier",
      "location": "Vorratsschrank",
      "unit": "Stück",
      "targetQuantity": 20,
      "stockQuantity": 10,
      "buyQuantity": 10,
    },
    {
      "name": "Jever Pils",
      "location": "Kühlschrank",
      "unit": "Flaschen",
      "targetQuantity": 100,
      "stockQuantity": 66,
      "buyQuantity": 34,
    },
    {
      "name": "Milch",
      "location": "Kühlschrank",
      "unit": "l",
      "targetQuantity": 2,
      "stockQuantity": 4,
      "buyQuantity": 0,
    },
    {
      "name": "Butter",
      "location": "Kühlschrank",
      "unit": "pck",
      "targetQuantity": 4,
      "stockQuantity": 2,
      "buyQuantity": 2,
    },
    {
      "name": "Fleischfreisalat",
      "location": "Kühlschrank",
      "unit": "Packung",
      "targetQuantity": 1,
      "stockQuantity": 0.6,
      "buyQuantity": 0.4,
    },
    {
      "name": "Spaghetti",
      "location": "Vorratsschrank",
      "unit": "Packung",
      "targetQuantity": 3,
      "stockQuantity": 2,
      "buyQuantity": 1,
    },
    {
      "name": "Tomaten, gehackt",
      "location": "Vorratsschrank",
      "unit": "Dosen",
      "targetQuantity": 3,
      "stockQuantity": 3,
      "buyQuantity": 0,
    },
    {
      "name": "Lösch mich, drück 'x'",
      "location": "Kleiderschrank",
      "unit": "Testeinheit",
      "targetQuantity": 1,
      "stockQuantity": 1,
      "buyQuantity": 0,
    },
  ],
};

class VerticalTabBar extends StatefulWidget {
  const VerticalTabBar({Key? key}) : super(key: key);

  @override
  _VerticalTabBarState createState() => _VerticalTabBarState();
}

class _VerticalTabBarState extends State<VerticalTabBar> {
  int selectedIndex = 0;
  PageController _pageController = PageController();
  Set<String> locations = {};

  void initState() {
    super.initState();

    // iterate over the list of items and collect the unique locations in a Map
    for (var item in storageMap["items"]) {
      locations.add(item["location"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SizedBox(
              width: 120,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: locations.length,
                      itemBuilder: (BuildContext context, int index) {
                        String location = locations.elementAt(index);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              print('setState $index');
                              selectedIndex = index;
                              _pageController.jumpToPage(selectedIndex);
                            });
                          },
                          child: Container(
                            child: Row(
                              children: [
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 400),
                                  height: (selectedIndex == index) ? 50 : 0,
                                  width: 5,
                                  color: Colors.teal,
                                ),
                                Expanded(
                                    child: AnimatedContainer(
                                  alignment: Alignment.center,
                                  duration: Duration(milliseconds: 500),
                                  height: 50,
                                  color: (selectedIndex == index)
                                      ? Colors.blueGrey.withOpacity(0.2)
                                      : Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 5),
                                    child: Text(location),
                                  ),
                                ))
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'New location',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Container(
              child: PageView(
                controller: _pageController,
                children: [
                  Container(
                    child: storageTabContent(
                        location: locations.elementAt(selectedIndex)),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // define text editing controllers for the input fields
              TextEditingController nameController = TextEditingController();
              TextEditingController unitController = TextEditingController();
              TextEditingController targetQuantityController =
                  TextEditingController();

              // define the dialog content
              return AlertDialog(
                title: Text('Neues Lebensmittel'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                    TextField(
                      controller: unitController,
                      decoration: InputDecoration(
                        labelText: 'Unit',
                      ),
                    ),
                    TextField(
                      controller: targetQuantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Target Quantity',
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.cancel_outlined),
                    onPressed: () {
                      // CLose Alert with No Operation
                      Navigator.of(context).pop();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.check_circle, color: Colors.teal),
                    onPressed: () {
                      // retrieve the values entered by the user
                      String name = nameController.text;
                      String unit = unitController.text;
                      int targetQuantity =
                          int.tryParse(targetQuantityController.text) ?? 0;
                      int stockQuantity = 0;
                      int buyQuantity = targetQuantity - stockQuantity;

                      // Create a new map object with the new entry details
                      Map<String, dynamic> newEntry = {
                        "name": name,
                        "location": locations.elementAt(selectedIndex),
                        "unit": unit,
                        "targetQuantity": targetQuantity,
                        "stockQuantity": stockQuantity,
                        "buyQuantity": buyQuantity,
                      };

                      // Add the new entry to the existing items list in the storageMap
                      List<Map<String, dynamic>> itemsList =
                          List<Map<String, dynamic>>.from(storageMap["items"]);
                      itemsList.addAll([newEntry]);

                      storageMap["items"] = itemsList;

                      // Refresh the TabView
                      setState(() {
                        selectedIndex = selectedIndex;
                        _pageController.jumpToPage(selectedIndex);
                      });

                      // Close AlertDialog
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}

// Baut den Inhalt der Lagerorte
class storageTabContent extends StatefulWidget {
  String location = '';

  storageTabContent({this.location = ''});

  @override
  _storageTabContentState createState() => _storageTabContentState();
}

class _storageTabContentState extends State<storageTabContent> {
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _items = storageMap['items']
        .where((item) => item['location'] == widget.location)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (BuildContext context, int index) {
        final item = _items[index];
        return Dismissible(
          key: UniqueKey(),
          background: Container(
            color: Colors.red,
            child: SizedBox(
              height: 30, // Customize the height of the button.
              width: 30, // Customize the width of the button.
              child: Icon(Icons.delete, color: Colors.white),
            ),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 10),
          ),
          onDismissed: (direction) {
            // remove the item from the list
            storageMap["items"].removeWhere((item) => item["name"] == _items[index].values.first);
          },
          child: ListTile(
            title: Text(item['name']),
            subtitle: Column(
              children: [
                Row(
                  children: [
                    Text('      Einheit: '),
                    Expanded(
                      child: TextFormField(
                        initialValue: item['unit'].toString(),
                        onFieldSubmitted: (value) => item['unit'] = value,
                        decoration: InputDecoration(
                          hintText: 'Einheit',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('      Bestand: '),
                    Expanded(
                      child: TextFormField(
                        initialValue: item['stockQuantity'].toString(),
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (value) =>
                        item['stockQuantity'] = int.parse(value),
                        decoration: InputDecoration(
                          hintText: 'Bestand',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('      Soll: '),
                    Expanded(
                      child: TextFormField(
                        initialValue: item['targetQuantity'].toString(),
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (value) =>
                        item['targetQuantity'] = int.parse(value),
                        decoration: InputDecoration(
                          hintText: 'Soll',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );

  }
}

// Ending of storageTabContent
