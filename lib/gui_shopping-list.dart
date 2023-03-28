import 'package:flutter/material.dart';


class shoppingList extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return new Container(
        child: new Center(
            child: new Icon(Icons.shopping_cart, size: 150.0, color: Colors.teal)
        )
    );
  }
}