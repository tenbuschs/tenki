import 'package:flutter/material.dart';
import 'tenki_icons.dart';
import 'tenki_colors.dart';

List<String> categories = [
  "Obst & Gemüse",
  "Backwaren",
  "Milchprodukte",
  "Fleisch & Fisch",
  "Vegi - Kühlregal",
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
  TenkiIcons.carot(size: 35, color: TenkiColor1()), // Obst & Gemüse
  TenkiIcons.brot(size: 35, color: TenkiColor1()), // Backwaren
  TenkiIcons.milchtuete(size: 35, color: TenkiColor1()), // Milchprodukte
  TenkiIcons.fish(size: 35, color: TenkiColor1()), // Fleisch und Fisch
  TenkiIcons.plant(size: 35, color: TenkiColor1()), // Vegi-Kühlregal
  TenkiIcons.chili(size: 35, color: TenkiColor1()), // Zutaten & Gewürze
  TenkiIcons.frosty(size: 35, color: TenkiColor1()), // Tiefkühlwaren
  TenkiIcons.grain(size: 35, color: TenkiColor1()), // Getreideprodukte
  TenkiIcons.cookie(size: 35, color: TenkiColor1()), // Snacks und Süßwaren
  TenkiIcons.wine(size: 35, color: TenkiColor1()), // Getränke
  TenkiIcons.toiletpaper(size: 35, color: TenkiColor1()), // Haushalt
  TenkiIcons.firstAid(size: 35, color: TenkiColor1()), // Pflege & Gesundheit
  TenkiIcons.hund(size: 35, color: TenkiColor1()), // Tierbedarf
  TenkiIcons.werkzeug(size: 35, color: TenkiColor1()), // Baumarkt & Garten
  TenkiIcons.geschenk(size: 35, color: TenkiColor1()), //  Eigene Artikel
  TenkiIcons.tenki(size: 35, color: TenkiColor1()), //  Sonstige
  TenkiIcons.tenki(size: 35, color: TenkiColor1()), //  uncategorised
];

class HelperCategoryItems {
  static Widget getCategoryWidget(String category) {
    int index = categories.indexOf(category);
    if (index != -1 && index < categoryItems.length) {
      return categoryItems[index];
    }
    return const Center(
        child: Text(
            "Item not found!")); // Return an empty widget if the category is not found or the index is out of bounds
  }
}
