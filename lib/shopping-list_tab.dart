import 'package:flutter/material.dart';
import 'dart:collection'; //for groupby fct
import 'data.dart' as data;

class ShoppingList extends StatefulWidget {
  const ShoppingList({Key? key}) : super(key: key);

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  @override
  Widget build(BuildContext context) {
    // preselection: group by shoppingCategory and remove buyQuantity=0
    Map<String, List<dynamic>> groupedItems = {};

    for (var item in data.storageMap['items']) {
      if (item['buyQuantity'] != 0) {
        if (!groupedItems.containsKey(item['shoppingCategory'])) {
          groupedItems[item['shoppingCategory']] = [];
        }
        groupedItems[item['shoppingCategory']]?.add(item);
      }
    }
    return Scaffold(
      body: ListView.builder(
        itemCount: groupedItems.length,
        itemBuilder: (BuildContext context, int index) {
          final category = groupedItems.keys.toList()[index];
          List<dynamic> items = groupedItems[category]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  category,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.teal,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];

                  return CheckboxListTile(
                    title: Text(
                        item['buyQuantity'].toString() + "x " + item['name']),
                    subtitle: Text(item['unit']),
                    value: data.isChecked.firstWhere(
                      (itemList) => itemList["name"] == item['name'],
                    )["isChecked"],
                    onChanged: (bool? value) {
                      setState(() {
                        //change state in isChecked list
                        data.isChecked.firstWhere((itemList) =>
                                itemList["name"] == item['name'])["isChecked"] =
                            value;

                        if (value == true) {
                          item['stockQuantity'] =
                              item['stockQuantity'] + item['buyQuantity'];
                          item['buyQuantity'] = 0;
                          data.isChecked.firstWhere((itemList) =>
                              itemList["name"] ==
                              item['name'])["isChecked"] = false;
                        }
                      });
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // define text editing controllers for the input fields
              TextEditingController nameController = TextEditingController();
              TextEditingController unitController = TextEditingController();
              TextEditingController buyQuantityController =
                  TextEditingController();

              // define the dialog content
              return AlertDialog(
                title: const Text('Extra Lebensmittel'),
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
                      controller: buyQuantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Buy Quantity',
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
                      double buyQuantity =
                          double.tryParse(buyQuantityController.text) ?? 0;

                      // Create a new map object with the new entry details
                      Map<String, dynamic> newEntry = {
                        "name": name,
                        "location": "xtra_item",
                        "unit": unit,
                        "targetQuantity": 0,
                        "stockQuantity": 0,
                        "buyQuantity": buyQuantity,
                        "shoppingCategory": "Extras",
                      };

                      // Add the new entry to the existing items list in the storageMap
                      List<Map<String, dynamic>> itemsList =
                          List<Map<String, dynamic>>.from(
                              data.storageMap["items"]);
                      itemsList.addAll([newEntry]);

                      // Refresh the View
                      setState(() {
                        data.storageMap["items"] = itemsList;
                        data.isChecked.add({"name": name, "isChecked": false});
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

  Map<String, List<dynamic>> groupBy(List<dynamic> list, Function keySelector) {
    Map<String, List<dynamic>> result = HashMap();
    list.forEach((element) {
      String key = keySelector(element).toString();
      if (!result.containsKey(key)) {
        result[key] = <dynamic>[];
      }
      result[key]!.add(element);
    });
    return result;
  }
}