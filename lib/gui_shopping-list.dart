import 'package:flutter/material.dart';
import 'dart:collection';   //for groupby fct
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
              physics: NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = items[index];

                return ListTile(
                  title: Text(item['buyQuantity'].toString() + "x " + item['name']),
                  subtitle: Text(item['unit']),
                  trailing: Checkbox(
                          value: item['buyQuantity'] == 1,
                          onChanged: (bool? value) {
                            setState(() {
                              item['buyQuantity'] = value! ? 1 : 0;
                              item['stockQuantity'] += value ? 1 : -1;
                            });
                          },
                      ),




                //  trailing: Text(item['buyQuantity'].toString()),
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




/*
class _shoppingListState extends State<shoppingList> {
  bool isChecked=false;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: storageMap["items"].length,
      itemBuilder: (BuildContext context, int index) {
        final item = storageMap["items"][index];
        return ListTile(
          title: Text(item["name"]),
          subtitle: Text("${item["buyQuantity"]} ${item["unit"]}"),
          trailing: Checkbox(
            value:  isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked= value!;
              });
            },
          ),
        );
      },

      /*  groupBy: (dynamic item) => item["shoppingCategory"],
      groupComparator: (String category1, String category2) => category1.compareTo(category2),
      itemComparator: (dynamic item1, dynamic item2) => item1["name"].compareTo(item2["name"]),
      groupHeaderBuilder: (String category) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          category,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
      ),*/
    );


  }
}
*/