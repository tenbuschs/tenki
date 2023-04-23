// *****************************************************************************************
// file:    tenki_icons.dart
// author:  Tenbusch, Simon
// date:    2023/04/16
//
//
// Example how to use
// 1. Import the file
// TenkiIcons.xyz(); // returns a 24x24 black icon
// TenkiIcons.xyz(size: 36, color: Colors.blue); // returns a 36x36 blue icon
// *****************************************************************************************

import 'package:flutter/material.dart';



class TenkiIcons {

  static Widget add({double size = 24, Color color = Colors.black}) {
    return _buildIcon('add', size, color);
  }

  static Widget apple({double size = 24, Color color = Colors.black}) {
    return _buildIcon('apple', size, color);
  }

  static Widget calendar({double size = 24, Color color = Colors.black}) {
    return _buildIcon('calendar', size, color);
  }

  static Widget carot({double size = 24, Color color = Colors.black}) {
    return _buildIcon('carot', size, color);
  }

  static Widget chili({double size = 24, Color color = Colors.black}) {
    return _buildIcon('chili', size, color);
  }

  static Widget citrone({double size = 24, Color color = Colors.black}) {
    return _buildIcon('citrone', size, color);
  }

  static Widget cookie({double size = 24, Color color = Colors.black}) {
    return _buildIcon('cookie', size, color);
  }

  static Widget cow({double size = 24, Color color = Colors.black}) {
    return _buildIcon('cow', size, color);
  }

  static Widget firstAid({double size = 24, Color color = Colors.black}) {
    return _buildIcon('first_aid', size, color);
  }

  static Widget fish({double size = 24, Color color = Colors.black}) {
    return _buildIcon('fish', size, color);
  }

  static Widget frosty({double size = 24, Color color = Colors.black}) {
    return _buildIcon('frosty', size, color);
  }

  static Widget grain({double size = 24, Color color = Colors.black}) {
    return _buildIcon('grain', size, color);
  }

  static Widget health({double size = 24, Color color = Colors.black}) {
    return _buildIcon('health', size, color);
  }

  static Widget ice({double size = 24, Color color = Colors.black}) {
    return _buildIcon('ice', size, color);
  }

  static Widget leaf({double size = 24, Color color = Colors.black}) {
    return _buildIcon('leaf', size, color);
  }

  static Widget logo({double size = 24, Color color = Colors.black}) {
    return _buildIcon('logo', size, color);
  }

  static Widget meat({double size = 24, Color color = Colors.black}) {
    return _buildIcon('meat', size, color);
  }

  static Widget milk({double size = 24, Color color = Colors.black}) {
    return _buildIcon('milk', size, color);
  }

  static Widget pin({double size = 24, Color color = Colors.black}) {
    return _buildIcon('pin', size, color);
  }

  static Widget pizza({double size = 24, Color color = Colors.black}) {
    return _buildIcon('pizza', size, color);
  }

  static Widget plant({double size = 24, Color color = Colors.black}) {
    return _buildIcon('plant', size, color);
  }

  static Widget settings({double size = 24, Color color = Colors.black}) {
    return _buildIcon('settings', size, color);
  }

  static Widget shopping_bag({double size = 24, Color color = Colors.black}) {
    return _buildIcon('shopping_bag', size, color);
  }

  static Widget shoppingList({double size = 24, Color color = Colors.black}) {
    return _buildIcon('shoppingList', size, color);
  }

  static Widget storage({double size = 24, Color color = Colors.black}) {
    return _buildIcon('storage', size, color);
  }

  static Widget tenki({double size = 24, Color color = Colors.black}) {
    return _buildIcon('tenki', size, color);
  }

  static Widget thermometer({double size = 24, Color color = Colors.black}) {
    return _buildIcon('thermometer', size, color);
  }

  static Widget weight({double size = 24, Color color = Colors.black}) {
    return _buildIcon('weight', size, color);
  }

  static Widget wine({double size = 24, Color color = Colors.black}) {
    return _buildIcon('wine', size, color);
  }

  // method to build a icon
  static Widget _buildIcon(String iconName, double size, Color color) {
    return Center(
      child: ImageIcon(
        AssetImage('lib/tenki_material/icons/$iconName.png'),
        size: size,
        color: color,
      ),
    );
  }

}


