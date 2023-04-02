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

    return ListView.builder(
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
                                itemList["name"] == item['name'])["isChecked"] =
                            false;
                      }
                    });
                  },
                );
              },
            ),
          ],
        );
      },
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
