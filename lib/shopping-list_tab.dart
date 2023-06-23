import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:TENKI/firestore_interface.dart';
import 'package:TENKI/tenki_material/tenki_colors.dart';
import 'package:TENKI/tenki_material/tenki_icons.dart';
import 'tenki_material/category_items.dart';
import 'dart:ui'; // for image filter; blur
import 'tenki_material/units.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({Key? key}) : super(key: key);

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // preselection: group by shoppingCategory and remove buyQuantity=0
    var groupedItems = <String, List<dynamic>>{};
    var checkedItems = <String, List<dynamic>>{};
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("storageMaps")
            .doc(householdId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Lädt..."));
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData) {
            // transfer to useful format
            final DocumentSnapshot<Map<String, dynamic>>? newData =
                snapshot.data;
            final Map<String, dynamic>? currentStorageMap =
                newData?.data()?['storageMap'];

            //grouping by shoppingCategory
            for (var item in currentStorageMap?['items']) {
              if (item['buyQuantity'] == null || item['buyQuantity'] != 0) {
                if (!groupedItems.containsKey(item['shoppingCategory'])) {
                  groupedItems[item['shoppingCategory']] = [];
                }
                groupedItems[item['shoppingCategory']]?.add(item);
              }
            }

            // List to save the state of the checkboxes in the shopping list
            // gui feature, that's why ishecked isnt stored in database
            List<Map<String, dynamic>> isChecked =
                List<Map<String, dynamic>>.from(currentStorageMap?["items"])
                    .map((item) {
              return {
                "name": item["name"],
                "isChecked": false,
              };
            }).toList();

            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFFE2DCCE), Color(0xFFFFFFFF)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    tileMode: TileMode.clamp),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Stack(
                    children: [
                      ListView.builder(
                        padding: const EdgeInsets.only(bottom: 100.0),
                        itemCount: groupedItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          final category = groupedItems.keys.toList()[index];
                          List<dynamic> items = groupedItems[category]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Stack(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        height: 15,
                                        color: index == 0
                                            ? Colors.white
                                            : TenkiColor3(),
                                      ),
                                      Container(
                                        height: 40,
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.grey,
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            category,
                                            style: const TextStyle(
                                              letterSpacing: 2,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 10,
                                        color: TenkiColor3(),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    left: 15,
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.grey, width: 1)),
                                      child:
                                          HelperCategoryItems.getCategoryWidget(
                                              category),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                color: TenkiColor3(),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: items.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final item = items[index];
                                    final checkValue = isChecked.firstWhere(
                                          (itemList) => itemList["name"] == item['name'],
                                      orElse: () => {},
                                    )["isChecked"];
                                    if (checkValue != null) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: TenkiColor1(),
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: Colors.grey.shade300),
                                          ),
                                          child: ListTile(
                                            title: Row(
                                              children: [
                                                Expanded(
                                                  flex: 4,
                                                  child: Text(item['name']),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: item['buyQuantity'] != null
                                                      ? Text(item['buyQuantity'].toString())
                                                      : const SizedBox(), // Display an empty SizedBox if buyQuantity is null
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: item['unit'] != "-Bitte wählen-"
                                                      ? Text(item['unit'])
                                                      : const SizedBox(),
                                                ),
                                              ],
                                            ),
                                            trailing: Checkbox(
                                              value: checkedItems.containsKey(item['name']),
                                              onChanged: (bool? value) async {
                                                if (value == true) {
                                                  // Item is checked
                                                  DatabaseInterface dbInterface = DatabaseInterface();

                                                  if (!checkedItems.containsKey(item['name'])) {
                                                    // Item is not in the checkedItems map, add it
                                                    checkedItems[item['name']] = [item];

                                                    // Update quantities or delete from DB based on item location
                                                    if (item["location"] != "xtra_item") {
                                                      await dbInterface.updateItemByName(item["name"], {
                                                        'stockQuantity': item['stockQuantity'] + item['buyQuantity'],
                                                        'buyQuantity': 0,
                                                      });
                                                    } else {
                                                      await dbInterface.deleteItemByName(item["name"]);
                                                    }
                                                  } else {
                                                    // Item is already in the checkedItems map, undo the check
                                                    checkedItems.remove(item['name']);

                                                    // Update quantities to remove the previously added buyQuantity
                                                    if (item["location"] != "xtra_item") {
                                                      await dbInterface.updateItemByName(item["name"], {
                                                        'stockQuantity': item['stockQuantity'] - item['buyQuantity'],
                                                        'buyQuantity': item['buyQuantity'],
                                                      });
                                                    }
                                                  }
                                                }

                                                // Refresh view
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      final checkedItemIndex = index - items.length;
                                      final checkedItemName = checkedItems.keys.toList()[checkedItemIndex];
                                      final checkedItem = checkedItems[checkedItemName]!;

                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: TenkiColor1(),
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: Colors.grey.shade300),
                                          ),
                                          child: ListTile(
                                            title: Row(
                                              children: [
                                                Expanded(
                                                  flex: 4,
                                                  child: Text(checkedItemName),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(checkedItem[0]['buyQuantity'].toString()), // Display the buyQuantity from the first item in the list
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(checkedItem[0]['unit'] != "-Bitte wählen-" ? checkedItem[0]['unit'] : ""), // Display the unit from the first item in the list
                                                ),
                                              ],
                                            ),
                                            trailing: Checkbox(
                                              value: true,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  checkedItems.remove(checkedItemName);
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      Positioned(
                        top: 5.0,
                        right: 5.0,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: TenkiColor3(),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  title: const Text('Wie funktioniert die TENKI Einkaufsliste?'),
                                  content: const Text(
                                      "Die Gegenstände deiner Einkaufsliste bestehen aus drei verschiedenen Gruppen:\nDie Differenz zwischen Soll und Ist Bestand deines Lagers. Diese werden live geupdatet, du musst also nur deine Bestände regelmäßig eintragen, dann ist deine Einkaufsliste auch immer aktuell.\nItems, die du für Rezepte brauchst: Diese kannst du bequem direkt im Rezept zur Einkaufsliste hinzufügen.\nArtikel, die du zwar nicht regelmäßig brauchst, aber für den nächsten Einkauf aufschreiben möchtest kannst du ganz einfach über das “plus” auf die Liste setzen.\nWenn du einkaufen warst, kannst du in der Liste die Artikel entweder abhaken - wir sie automatisch in deinen Vorrat."),
                                  actions: [
                                    Center(
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: TenkiColor1(),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(7.0),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0, vertical: 8.0),
                                          elevation: 3.0,
                                        ),
                                        child: const Text(
                                          'Verstanden',
                                          style:
                                          TextStyle(color: Colors.black87, letterSpacing: 1.5),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            side: const BorderSide(width: 1.0, color: Colors.black87),
                            elevation: 3.0,
                            backgroundColor: TenkiColor3(),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.black87,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // blurred bottom part
                      Positioned(
                        bottom: 0.0,
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              height: 100.0,
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  floatingActionButton: _buttonAddExtraItem(context)
              ),
            );
          } else {
            return const Center(child: Text("Unexpected Error"));
          }
        });
  }

  Widget _buttonAddExtraItem(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // define text editing controllers for the input fields
            TextEditingController nameController = TextEditingController();
            TextEditingController buyQuantityController =
                TextEditingController();
            String? selectedUnit = "-Bitte wählen-";

            return AlertDialog(
              title: const Center(child: Text('Extra-Artikel hinzufügen')),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: nameController,
                      cursorColor: TenkiColor1(),
                      maxLength: 20,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle:
                            TextStyle(color: Colors.grey[700], fontSize: 16),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: TenkiColor1(), width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextField(
                      controller: buyQuantityController,
                      keyboardType: TextInputType.number,
                      cursorColor: TenkiColor1(),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                      decoration: InputDecoration(
                        labelText: 'Menge',
                        labelStyle:
                            TextStyle(color: Colors.grey[700], fontSize: 16),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: TenkiColor1(), width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                      ),

                    ),
                    const SizedBox(height: 25),
                    DropdownButtonFormField<String>(
                      value: selectedUnit,
                      items: unitList.map((option) {
                        return DropdownMenuItem(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedUnit = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Einheit',
                        labelStyle: TextStyle(color: Colors.grey[700]),
                        border: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide(color: TenkiColor1()),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: TenkiColor1(), width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                      ),
                      dropdownColor: TenkiColor2(),
                    ),
                    const SizedBox(height: 15),
                    /* HorizontalSelection(
                      itemIcons: categoryItems,
                      onSelect: (int index) {
                        // NOP
                      },
                    ),*/
                  ],
                ),
              ),
              actions: <Widget>[
                InkWell(
                  onTap: () {
                    // Close button action
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 1),
                      color: TenkiColor4(),
                    ),
                    child: const Icon(Icons.close),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    // Confirm button action

                    // Check if name and unit have been selected
                    if (nameController.text.isNotEmpty) {
                      // retrieve the values entered by the user
                      String name = nameController.text;
                      String? unit = selectedUnit;
                      double? buyQuantity = buyQuantityController.text.isNotEmpty
                          ? double.tryParse(buyQuantityController.text)
                          : null;

                      // Create a new map object with the new entry details
                      Map<String, dynamic> newEntry = {
                        "name": name,
                        "location": "xtra_item",
                        "unit": unit,
                        "targetQuantity": 0,
                        "stockQuantity": 0,
                        "buyQuantity": buyQuantity,
                        "shoppingCategory": "Eigene Artikel",
                      };

                      // call function to add the new item
                      DatabaseInterface dbInterface = DatabaseInterface();
                      await dbInterface.addItemToStorageMap(newEntry);

                      // Refresh the View
                      setState(() {});

                      // Close AlertDialog
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    } else {
                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Bitte gib einen Artikel ein!'),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 1),
                      color: TenkiColor1(),
                    ),
                    child: const Icon(Icons.check),
                  ),
                ),
              ],
              backgroundColor: TenkiColor3(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.black, width: 1),
              ),
            );
          },
        );
      },
      backgroundColor: TenkiColor2(),
      shape: const CircleBorder(
        side: BorderSide(color: Colors.black87, width: 1),
      ),
      child: TenkiIcons.add(size: 35, color: Colors.black87),
    );
  }
}