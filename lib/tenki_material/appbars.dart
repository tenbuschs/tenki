import 'package:flutter/material.dart';
import 'package:tenki/tenki_material/tenki_colors.dart';
import 'tenki_icons.dart';
import 'package:tenki/logout_page.dart' as logout_page;
import 'package:tenki/profile_page.dart' as profile_page;
import 'package:tenki/settings_page.dart' as settings_page;
import 'package:tenki/about_tenki_page.dart' as about_tenki_page;
import 'package:tenki/feedback_page.dart' as feedback_page;
import 'package:tenki/homepage.dart' as homepage;


class AppBars{

  static AppBar mainAppBar(String title, BuildContext context){

    return AppBar(
      leading: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => homepage.TenkiHomePage()),
          );
        },
        child: TenkiIcons.tenki(size: 38),
      ),
      title: Center(
        child: Text(title, style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          letterSpacing: 5,
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
                  child: Text("Mein TENKI", style: TextStyle(fontWeight: FontWeight.w400)),
                ),

                const PopupMenuItem<int>(
                  value: 1,
                  child: Text("Einstellungen", style: TextStyle(fontWeight: FontWeight.w400)),
                ),

                const PopupMenuItem<int>(
                  value: 2,
                  child: Text("Über uns", style: TextStyle(fontWeight: FontWeight.w400)),
                ),
                const PopupMenuItem<int>(
                  value: 3,
                  child: Text("Feedback", style: TextStyle(fontWeight: FontWeight.w400)),
                ),
                const PopupMenuItem<int>(
                  value: 4,
                  child: Text("Logout", style: TextStyle(fontWeight: FontWeight.w400)),
                ),
              ];
            },
            onSelected:(value){
              if(value == 0){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const profile_page.MyTenki()),
                );
              } else if(value == 1){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const settings_page.Settings()),
                );
              } else if(value == 2){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const about_tenki_page.AboutTenki()),
                );
              } else if(value == 3){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const feedback_page.Feedback()),
                );
              } else if(value == 4){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => logout_page.LogoutPage()),
                );
              }


            }
        ),
      ],

    );

  }



  static AppBar dropdownAppBar(String title, BuildContext context){

    return AppBar(
      leading: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => homepage.TenkiHomePage()),
          );
        },
        child: TenkiIcons.tenki(size: 38),
      ),
      backgroundColor: TenkiColor2(),
     title: Center(
        child: Text(title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            letterSpacing: 5,
          ),),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.close, color: Colors.black, size: 35),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }


  static AppBar loginAppBar(String title, BuildContext context){
    return AppBar(
      leading: TenkiIcons.tenki(size: 38),
      backgroundColor: TenkiColor2(),
      centerTitle: true, // add this line to center the title text
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          letterSpacing: 5,
        ),
      ),
    );
  }
}