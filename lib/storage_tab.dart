import 'package:flutter/material.dart';
import 'barcode_scan.dart' as barcode_scan_page;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_interface.dart';

class VerticalTabBar extends StatefulWidget {
  const VerticalTabBar({Key? key}) : super(key: key);

  @override
  _VerticalTabBarState createState() => _VerticalTabBarState();
}

class _VerticalTabBarState extends State<VerticalTabBar> {
  int selectedIndex = 0;
  final PageController _pageController = PageController();
  Set<String> locations = {};
  TextEditingController newLocationController = TextEditingController();

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("storageMaps")
              .doc(uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text("Waiting..."));
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.hasData) {
              // transfer to useful format
              final DocumentSnapshot<Map<String, dynamic>>? newData =
                  snapshot.data;
              final Map<String, dynamic>? currentStorageMap =
                  newData?.data()?['storageMap'];

              if (currentStorageMap?['items'].isEmpty) {
                return Center(
                    child: Text(
                        "TODO: Leere Liste handeln! ActionFloatingButton deaktivieren und Möglichkeit schaffen um den ersten Lagerort anlegen zu können."));
              } else {
                // iterate over the list of items and collect the unique locations in a Map
                for (var item in currentStorageMap?["items"]) {
                  if (item["location"] != "xtra_item") {
                    //Extras are not shown in storage
                    locations.add(item["location"]);
                  }
                }

                // TODO: SafeArea als Widget ausgliedern! Übersichtlichkeit herstellen
                return SafeArea(
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
                                        selectedIndex = index;
                                        _pageController
                                            .jumpToPage(locations.length + 1);
                                        /*  Iwi ist der pageController buggy. Eigentlich war der Plan:
                                          _pageController.jumpToPage(selectedIndex);
                                          aber dann gibts Probleme bei index=0, da die Function auf != null prueft
                                          Aber dieser Workaround (Wert über dem Gültigkeitsbereich) klappt iwi aktuell
                                      */
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.delete,
                                                      color: Colors.white),
                                                  onPressed: () {
                                                    if (locations.length > 1) {
                                                      List<dynamic> items =
                                                          currentStorageMap?[
                                                              "items"];
                                                      items.removeWhere(
                                                          (item) =>
                                                              item[
                                                                  "location"] ==
                                                              locations
                                                                      .toList()[
                                                                  index]);

                                                      setState(() {
                                                        // update data
                                                        currentStorageMap?[
                                                            "items"] = items;

                                                        // refresh view
                                                        List<String>
                                                            locationsList =
                                                            locations.toList();
                                                        locationsList
                                                            .removeAt(index);

                                                        locations =
                                                            locationsList
                                                                .toSet();
                                                        selectedIndex = 0;
                                                        _pageController
                                                            .jumpToPage(locations
                                                                    .length +
                                                                1);
                                                      });
                                                    } else {
                                                      // TODO: show the user, why it not works
                                                      // print('Delet Location not possible');
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
                                    child: Row(
                                      children: [
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 400),
                                          height:
                                              (selectedIndex == index) ? 50 : 0,
                                          width: 5,
                                          color: Colors.teal,
                                        ),
                                        Expanded(
                                            child: AnimatedContainer(
                                          alignment: Alignment.center,
                                          duration:
                                              const Duration(milliseconds: 500),
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
                                  );
                                },
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: newLocationController,
                                      decoration: const InputDecoration(
                                        hintText: 'New location',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      // add new location to location list if their is text in input field
                                      if (newLocationController.text != "") {
                                        locations
                                            .add(newLocationController.text);
                                        // make input field empty
                                        newLocationController.text = "";
                                      } else {
                                        // print("Missing Text Input. Cant add new location");
                                      }
                                      //print("new location list: $locations");

                                      // show new location in list and jump to it
                                      setState(() {
                                        selectedIndex = locations.length - 1;
                                        _pageController
                                            .jumpToPage(selectedIndex);
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
                        child: PageView(
                          controller: _pageController,
                          children: [
                            Container(
                              child: storageTabContent(
                                  location: locations.elementAt(selectedIndex)),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
            } else {
              return const Center(child: Text("Unexpected Error"));
            }
          }),
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
                title: const Text('Neues Lebensmittel'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                    TextField(
                      controller: unitController,
                      decoration: const InputDecoration(
                        labelText: 'Unit',
                      ),
                    ),
                    TextField(
                      controller: targetQuantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Target Quantity',
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.barcode_reader),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return barcode_scan_page.BarcodeScanner();
                          });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel_outlined),
                    onPressed: () {
                      // CLose Alert with No Operation
                      Navigator.of(context).pop();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.check_circle, color: Colors.teal),
                    onPressed: () async {
                      // retrieve the values entered by the user
                      String name = nameController.text;
                      String unit = unitController.text;
                      double targetQuantity =
                          double.tryParse(targetQuantityController.text) ?? 0;
                      double stockQuantity = 0;
                      double buyQuantity = targetQuantity - stockQuantity;

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

                      // call function to add the new item
                      DatabaseInterface dbInterface = DatabaseInterface();
                      await dbInterface.addItemToStorageMap(newEntry);

                      // Refresh the TabView
                      setState(() {
                        selectedIndex = selectedIndex;
                        _pageController.jumpToPage(locations.length + 1);
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
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
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
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("storageMaps")
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Waiting..."));
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData) {
            // transfer to useful format
            final DocumentSnapshot<Map<String, dynamic>>? newData =
                snapshot.data;
            final Map<String, dynamic>? currentStorageMap =
                newData?.data()?['storageMap'];

            // just the items for the current location
            _items = currentStorageMap?['items']
                .where((item) => item['location'] == widget.location)
                .toList()
                .cast<Map<String, dynamic>>();

            if (_items.length > 0) {
              return ListView.builder(
                itemCount: _items.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = _items[index];
                  return Dismissible(
                    key: UniqueKey(),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 10),
                      child: const SizedBox(
                        height: 30, // Customize the height of the button.
                        width: 30, // Customize the width of the button.
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                    ),
                    onDismissed: (direction) {
                      // remove the item from the list
                      currentStorageMap?["items"].removeWhere(
                          (item) => item["name"] == _items[index].values.first);
                    },
                    child: ListTile(
                      title: Text(item['name']),
                      subtitle: Column(
                        children: [
                          Row(
                            children: [
                              const Text('      Einheit: '),
                              Expanded(
                                child: TextFormField(
                                  initialValue: item['unit'].toString(),
                                  onFieldSubmitted: (value) async {
                                    DatabaseInterface dbInterface =
                                        DatabaseInterface();
                                    await dbInterface.updateItemByName(
                                        item["name"], {'unit': value});
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Einheit',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text('      Bestand: '),
                              Expanded(
                                child: TextFormField(
                                  initialValue:
                                      item['stockQuantity'].toString(),
                                  keyboardType: TextInputType.number,
                                  onFieldSubmitted: (value) =>
                                      updateStockQuantity(value, item),
                                  decoration: const InputDecoration(
                                    hintText: 'Bestand',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text('      Soll: '),
                              Expanded(
                                child: TextFormField(
                                  initialValue:
                                      item['targetQuantity'].toString(),
                                  keyboardType: TextInputType.number,
                                  onFieldSubmitted: (value) =>
                                      updateTargetQuantity(value, item),
                                  decoration: const InputDecoration(
                                    hintText: 'Soll',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Container(child: Text("Leer"));
            }
          } else {
            return Center(child: Text("UnexpectedError"));
          }
        });
  }
}

// Ending of storageTabContent

Future<void> updateTargetQuantity(
    String value, Map<String, dynamic> item) async {
  DatabaseInterface dbInterface = DatabaseInterface();

  if (double.parse(value) - item['stockQuantity'] <= 0) {
    await dbInterface.updateItemByName(item["name"], {'buyQuantity': 0});
  } else {
    await dbInterface.updateItemByName(item["name"],
        {'buyQuantity': double.parse(value) - item['stockQuantity']});
  }

  await dbInterface
      .updateItemByName(item["name"], {'targetQuantity': double.parse(value)});
}

Future<void> updateStockQuantity(
    String value, Map<String, dynamic> item) async {
  DatabaseInterface dbInterface = DatabaseInterface();

  if (item['targetQuantity'] - double.parse(value) <= 0) {
    await dbInterface.updateItemByName(item["name"], {'buyQuantity': 0});
  } else {
    await dbInterface.updateItemByName(item["name"],
        {'buyQuantity': item['targetQuantity'] - double.parse(value)});
  }
  await dbInterface
      .updateItemByName(item["name"], {'stockQuantity': double.parse(value)});
}
