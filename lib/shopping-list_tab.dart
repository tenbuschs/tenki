import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tenki/firestore_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

    String uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder(
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

            //grouping by shoppingCategory
            for (var item in currentStorageMap?['items']) {
              if (item['buyQuantity'] != 0) {
                if (!groupedItems.containsKey(item['shoppingCategory'])) {
                  groupedItems[item['shoppingCategory']] = [];
                }
                groupedItems[item['shoppingCategory']]?.add(item);
              }
            }

            // List to save the state of the checkboxes in the shopping list
            // gui feature, thats why ishecked isnt stored in database
            List<Map<String, dynamic>> isChecked =
                List<Map<String, dynamic>>.from(currentStorageMap?["items"])
                    .map((item) {
              return {
                "name": item["name"],
                "isChecked": false,
              };
            }).toList();

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFFE2DCCE), Color(0xFFFFFFFF)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    tileMode: TileMode.clamp),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Scaffold(
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
                                title: Text(item['buyQuantity'].toString() +
                                    "x " +
                                    item['name']),
                                subtitle: Text(item['unit']),
                                value: isChecked.firstWhere(
                                  (itemList) => itemList["name"] == item['name'],
                                )["isChecked"],
                                onChanged: (bool? value) async {
                                  if (value == true) {
                                    DatabaseInterface dbInterface =
                                        DatabaseInterface();
                                    await dbInterface.updateItemByName(
                                        item["name"], {
                                      'stockQuantity': item['stockQuantity'] +
                                          item['buyQuantity'],
                                      'buyQuantity': 0
                                    });
                                  }

                                  //refresh view
                                  setState(() {});
                                },
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  floatingActionButton: _buttonAddExtraItem(context)),
            );
          } else {
            return const Center(child: Text("Unexpected Error"));
          }
        });
  }

  /* wird iwi nicht gebraucht....

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
*/

  Widget _buttonAddExtraItem(BuildContext context) {
    return FloatingActionButton(
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
                  onPressed: () async {
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

                    // call function to add a new Extra-item
                    DatabaseInterface dbInterface = DatabaseInterface();
                    await dbInterface.addItemToStorageMap(newEntry);

                    // Refresh the View
                    setState(() {});

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
    );
  }
} // ending class _ShoppingListState
