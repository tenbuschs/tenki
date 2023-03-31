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

    // iterate over the list of items and collect the unique locations in a set
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
                child:  ListView.builder(
                  itemCount: locations.length,
                  itemBuilder: (BuildContext context, int index) {
                    String location = locations.elementAt(index);
                    return GestureDetector(
                      onTap: (){
                        setState((){
                          selectedIndex = index;
                          _pageController.jumpToPage(index);
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
                                  color: (selectedIndex == index) ? Colors.blueGrey.withOpacity(0.2) : Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical:0, horizontal:5),
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
            Expanded(
              child: Container(
                child: PageView(
                  controller: _pageController,
                  children: [
                        Container(
                          child:  storageTabContent(location: locations.elementAt(selectedIndex)),
                        )
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}



// Baut den Inhalt der Lagerorte
class storageTabContent extends StatefulWidget {
  String location='as';

  storageTabContent({this.location=''});

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
        return ListTile(
          title: Text(item['name']),
          subtitle: Column(
          //  crossAxisAlignment: CrossAxisAlignment.start,
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
                      item['stockQuantity'] = double.parse(value),
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
                      item['targetQuantity'] = double.parse(value),
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
        );
      },
    );
  }
}

// Ending of storageTabContent
