//import 'package:flutter/material.dart';

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
      "shoppingCategory": "Tiefkühl",
    },
   /* {
      "name": "Fischstäbchen",
      "location": "Tiefkühltruhe",
      "unit": "Packung a 18 Stück",
      "targetQuantity": 2,
      "stockQuantity": 2,
      "buyQuantity": 0,
      "shoppingCategory": "Tiefkühl",
    },
    {
      "name": "Notfallpizza",
      "location": "Tiefkühltruhe",
      "unit": "Stück",
      "targetQuantity": 3,
      "stockQuantity": 2,
      "buyQuantity": 1,
      "shoppingCategory": "Sonstige",
    },
    {
      "name": "Kartoffeln",
      "location": "Keller",
      "unit": "Säcke á 2,5kg",
      "targetQuantity": 2,
      "stockQuantity": 0,
      "buyQuantity": 2,
      "shoppingCategory": "Obst und Gemüse",
    },
    {
      "name": "Zwiebeln",
      "location": "Keller",
      "unit": "kg",
      "targetQuantity": 1,
      "stockQuantity": 0,
      "buyQuantity": 1,
      "shoppingCategory": "Obst und Gemüse",
    },
    {
      "name": "Karotten",
      "location": "Keller",
      "unit": "kg",
      "targetQuantity": 1,
      "stockQuantity": 0.5,
      "buyQuantity": 0.5,
      "shoppingCategory": "Sonstige",
    },
    {
      "name": "Eier",
      "location": "Vorratsschrank",
      "unit": "Stück",
      "targetQuantity": 20,
      "stockQuantity": 10,
      "buyQuantity": 10,
      "shoppingCategory": "Sonstige",
    },
    {
      "name": "Jever Pils",
      "location": "Kühlschrank",
      "unit": "Flaschen",
      "targetQuantity": 100,
      "stockQuantity": 66,
      "buyQuantity": 34,
      "shoppingCategory": "Getränke",
    },
    {
      "name": "Milch",
      "location": "Kühlschrank",
      "unit": "l",
      "targetQuantity": 2,
      "stockQuantity": 4,
      "buyQuantity": 0,
      "shoppingCategory": "Sonstige",
    },
    {
      "name": "Butter",
      "location": "Kühlschrank",
      "unit": "pck",
      "targetQuantity": 4,
      "stockQuantity": 2,
      "buyQuantity": 2,
      "shoppingCategory": "Sonstige",
    },
    {
      "name": "Fleischfreisalat",
      "location": "Kühlschrank",
      "unit": "Packung",
      "targetQuantity": 1,
      "stockQuantity": 0.6,
      "buyQuantity": 0.4,
      "shoppingCategory": "Sonstige",
    },
    {
      "name": "Spaghetti",
      "location": "Vorratsschrank",
      "unit": "Packung",
      "targetQuantity": 3,
      "stockQuantity": 2,
      "buyQuantity": 1,
      "shoppingCategory": "Sonstige",
    },
    {
      "name": "Tomaten, gehackt",
      "location": "Vorratsschrank",
      "unit": "Dosen",
      "targetQuantity": 3,
      "stockQuantity": 3,
      "buyQuantity": 0,
      "shoppingCategory": "Sonstige",
    },*/
    {
      "name": "Lösch mich (Swipe)",
      "location": "Kleiderschrank",
      "unit": "Testeinheit",
      "targetQuantity": 1,
      "stockQuantity": 1,
      "buyQuantity": 0,
      "shoppingCategory": "Sonstige",
    },
  ],
};

// List to save the state of the checkboxes in the shopping list
List<Map<String, dynamic>> isChecked =
    List<Map<String, dynamic>>.from(storageMap["items"]).map((item) {
  return {
    "name": item["name"],
    "isChecked": false,
  };
}).toList();
