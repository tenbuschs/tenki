import 'package:flutter/material.dart';
import 'data.dart' as data;



class VerticalTabBar extends StatefulWidget {
  const VerticalTabBar({Key? key}) : super(key: key);

  @override
  _VerticalTabBarState createState() => _VerticalTabBarState();
}

class _VerticalTabBarState extends State<VerticalTabBar> {
  int selectedIndex = 0;
  PageController _pageController = PageController();
  Set<String> locations = {};
  TextEditingController newLocationController = TextEditingController();

  void initState() {
    super.initState();

    // iterate over the list of items and collect the unique locations in a Map
    for (var item in data.storageMap["items"]) {
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

                          onLongPress: () {
                            // Show delete button
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 100,
                                  color: Colors.redAccent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.white),

                                        onPressed: () {

                                          if(locations.length>1) {
                                            List<dynamic> items = data
                                                .storageMap["items"];
                                            items.removeWhere((item) =>
                                            item["location"] ==
                                                locations.toList()[index]);

                                            setState(() {
                                              // update data
                                              data.storageMap["items"] = items;

                                              // refresh view
                                              List<
                                                  String> locationsList = locations
                                                  .toList();
                                              locationsList.removeAt(index);
                                              locations = locationsList.toSet();
                                              selectedIndex = 0;
                                              _pageController.jumpToPage(
                                                  selectedIndex);
                                            });
                                          }
                                          else{
                                            // TODO: show the user, why it not works
                                            print('Delet Location not possible');
                                          }

                                          Navigator.pop(context);
                                        },

                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
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
                            controller: newLocationController,
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
                          onPressed: () {

                            // add new location to location list if their is text in input field
                            if(newLocationController.text!="") {
                              locations.add(newLocationController.text);
                              // make input field empty
                              newLocationController.text = "";
                            }
                            else {
                              print("Missing Text Input. Cant add new location");
                            }
                            print("new location list: $locations");

                            // show new location in list and jump to it
                            setState(() {
                              selectedIndex = locations.length-1;
                              _pageController.jumpToPage(selectedIndex);
                            });
                            // TODO: Automatic scroll to focused location

                          },
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
              TextEditingController targetQuantityController =  TextEditingController();

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
                        "shoppingCategory": "Sonstige",
                      };

                      // Add the new entry to the existing items list in the storageMap
                      List<Map<String, dynamic>> itemsList =
                          List<Map<String, dynamic>>.from(data.storageMap["items"]);
                      itemsList.addAll([newEntry]);

                      data.storageMap["items"] = itemsList;

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
    _items = data.storageMap['items']
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
            data.storageMap["items"].removeWhere((item) => item["name"] == _items[index].values.first);
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
                        onFieldSubmitted: (value) => updateStockQuantity(value, item),
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
                        onFieldSubmitted: (value) => updateTargetQuantity(value, item),

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


void updateTargetQuantity(String value, Map<String, dynamic> item) {

  if(double.parse(value)-item['stockQuantity']<=0)
    {
      item['buyQuantity'] =0;
    }
  else{
    item['buyQuantity'] = double.parse(value)-item['stockQuantity'];
  }

  item['targetQuantity'] = double.parse(value);

}


void updateStockQuantity(String value, Map<String, dynamic> item) {


  if(item['targetQuantity']-double.parse(value)<=0)
  {
    item['buyQuantity'] =0;
  }
  else{
    item['buyQuantity'] = item['targetQuantity']-double.parse(value);
  }

  item['stockQuantity'] = double.parse(value);

}