import 'package:flutter/material.dart';
import 'package:planner/consts/consts.dart';

import '../db/db_helper.dart';
import '../models/user.dart';
import '../pages/profile_page.dart';
import '../pages/welcome_page.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Drawer(child: Column(
      children: [
        SizedBox(height: 100,),
        InkWell(child: Text("Account", style: TextStyle(color: Consts.textColor, fontSize: 20),), onTap: (){
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
              builder: (context) => ProfilePage(user: user,)),
          (ret) => true);
        },),
        SizedBox(height: 20,),
        InkWell(child: Text("Sign out", style: TextStyle(color: Consts.textColor, fontSize: 20),), onTap: ()
          async {
            User usr = User(
                id: user.id,
                username: user.username,
                email: user.email,
                passwordHash: user.passwordHash,
                isAuthorized: 0);
            await DatabaseHelper.instance.updateUser(usr);
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const WelcomePage()));
          },
        )
      ],
    ),);
  }

}
