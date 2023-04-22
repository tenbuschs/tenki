import 'package:flutter/material.dart';
import 'package:tenki/tenki_material/tenki_colors.dart';
import 'tenki_icons.dart';
import 'package:tenki/logout_page.dart' as logout_page;
import 'package:tenki/profile_page.dart' as profile_page;
import 'package:tenki/settings_page.dart' as settings_page;
import 'package:tenki/about_tenki_page.dart' as about_tenki_page;
import 'package:tenki/feedback_page.dart' as feedback_page;


class AppBars{

  static AppBar mainAppBar(String title, BuildContext context){

    return AppBar(
      leading: TenkiIcons.tenki(size: 38),
      //TODO: Leading as button to welcome page
      title: Center(
        child: Text(title, style: const TextStyle(
          color: Colors.black,
        ),),
      ),
      backgroundColor: TenkiColor2(),
      actions: [
        PopupMenuButton(
            icon: const Icon(Icons.more_vert, color:Colors.black, size: 35),
            itemBuilder: (context){
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("Mein TENKI"),
                ),

                const PopupMenuItem<int>(
                  value: 1,
                  child: Text("Einstellungen"),
                ),

                const PopupMenuItem<int>(
                  value: 2,
                  child: Text("Logout"),
                ),
                const PopupMenuItem<int>(
                  value: 3,
                  child: Text("About us"),
                ),
                const PopupMenuItem<int>(
                  value: 4,
                  child: Text("Feedback"),
                ),
              ];
            },
            onSelected:(value){
              if(value == 0){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => profile_page.MyTenki()),
                );
              }else if(value == 1){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => settings_page.Settings()),
                );
              }else if(value == 2){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => logout_page.LogoutPage()),
                );
              }else if(value==3){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => about_tenki_page.AboutTenki()),
                );
              }else if(value==4){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => feedback_page.Feedback()),
                );
              }

            }
        ),
      ],

    );

  }



  static AppBar dropdownAppBar(String title, BuildContext context){

    return AppBar(
      leading: TenkiIcons.tenki(size: 38),
      backgroundColor: TenkiColor2(),
      //TODO: Leading as button to welcome page
      title: Center(
        child: Text(title,
          style: const TextStyle(
            color: Colors.black,
          ),),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 35),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }



}