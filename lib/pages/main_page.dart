import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planner/consts/consts.dart';
import 'package:planner/db/db_helper.dart';
import 'package:planner/models/user.dart';
import 'package:planner/pages/add_note_page.dart';
import 'package:planner/pages/calendar.dart';
import 'package:planner/pages/notes_page.dart';
import 'package:planner/pages/welcome_page.dart';
import 'package:planner/widgets/drawer_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.index, required this.user})
      : super(key: key);

  final int index;

  final User user;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  void initState() {
    super.initState();
    Consts.pressedIndex = widget.index;
  }

  void _onItemTapped(int index) {
    setState(() {
      Consts.pressedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var pages = [
      Calendar(user: widget.user),
      NotesPage(user: widget.user,)
    ];
    return Scaffold(
        backgroundColor: Colors.white,
        drawer: DrawerWidget(user: widget.user),
        appBar: AppBar(
          centerTitle: true,
          title: Text(Consts.pressedIndex==0?"Events":"Notes",style: TextStyle(color: Consts.textColor, fontSize: 20),),
        iconTheme: IconThemeData(color: Consts.textColor),
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,

        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.calendar),
              label: '.',
            ),
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.square_list),
              label: '.',
            ),
          ],
          iconSize: 25,
         showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedItemColor: Consts.btnColor,
          currentIndex: Consts.pressedIndex,
          selectedItemColor: Consts.textColor,
          onTap: _onItemTapped,
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(5),
          child: pages[Consts.pressedIndex],
        ),

      );
  }


}
