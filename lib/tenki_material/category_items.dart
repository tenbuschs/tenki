import 'package:flutter/material.dart';
import 'tenki_icons.dart';
import 'tenki_colors.dart';

List<String> categories = [
  "Obst & Gemüse",
  "Backwaren",
  "Milchprodukte",
  "Fleisch & Fisch",
  "Zutaten & Gewürze",
  "Tiefkühlwaren",
  "Getreideprodukte",
  "Snacks und Süßwaren",
  "Getränke",
  "Haushalt",
  "Pflege & Gesundheit",
  "Tierbedarf",
  "Baumarkt & Garten",
  "Eigene Artikel",
  "Sonstige",
  "uncategorised"
];


List<Widget> categoryItems = [
  TenkiIcons.carot(size: 35, color: TenkiColor1()),           // Obst & Gemüse
  TenkiIcons.shopping_bag(size: 35, color: TenkiColor1()),    // Todo Backwaren
  TenkiIcons.cow(size: 35, color: TenkiColor1()),             // Milchprodukte
  TenkiIcons.fish(size: 35, color: TenkiColor1()),            // Fleisch und Fisch
  TenkiIcons.chili(size: 35, color: TenkiColor1()),           // Zutaten & Gewürze
  TenkiIcons.frosty(size: 35, color: TenkiColor1()),          // Tiefkühlwaren
  TenkiIcons.grain(size: 35, color: TenkiColor1()),           // Getreideprodukte
  TenkiIcons.cookie(size: 35, color: TenkiColor1()),          // Snacks und Süßwaren
  TenkiIcons.wine(size: 35, color: TenkiColor1()),            // Getränke
  TenkiIcons.shopping_bag(size: 35, color: TenkiColor1()),    // Todo: Haushalt
  TenkiIcons.firstAid(size: 35, color: TenkiColor1()),        // Pflege & Gesundheit
  TenkiIcons.shopping_bag(size: 35, color: TenkiColor1()),    // Todo: Tierbedarf
  TenkiIcons.shopping_bag(size: 35, color: TenkiColor1()),    // Todo: Baumarkt & Garten
  TenkiIcons.tenki(size: 35, color: TenkiColor1()),           // Todo: Eigene Artikel
  TenkiIcons.storage(size: 35, color: TenkiColor1()),         // Todo: Sonstige
  TenkiIcons.tenki(size: 35, color: TenkiColor1()),           // Todo: uncategorised
];


class HelperCategoryItems {

  static Widget getCategoryWidget(String category) {
    int index = categories.indexOf(category);
    if (index != -1 && index < categoryItems.length) {
      return categoryItems[index];
    }
    return const Center(child: Text(
        "Item not found!")); // Return an empty widget if the category is not found or the index is out of bounds
  }

}