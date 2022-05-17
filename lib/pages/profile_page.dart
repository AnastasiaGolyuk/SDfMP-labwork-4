import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planner/consts/consts.dart';
import 'package:planner/models/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.user, }) : super(key: key);

  final User user;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Consts.bgColor,
        appBar: AppBar(
            backgroundColor: Consts.bgColor,
            shadowColor: Colors.transparent,
            iconTheme: IconThemeData(color: Consts.textColor),
            leading: IconButton(
                icon: const Icon(CupertinoIcons.back),
                onPressed: () {
                  Navigator.pop(context);
                })),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              width: Consts.getWidth(context),
              child: Text(
                "Labwork 4",
                style: TextStyle(
                    fontSize: 25,
                    color: Consts.textColor,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: const Image(
                image: AssetImage('assets/icons/account.png'),
                width: 150,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              width: Consts.getWidth(context),
              child: Text(
               widget.user.username,
                style: TextStyle(
                    fontSize: 20, color: Consts.textColor),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              width: Consts.getWidth(context),
              child: Text(
                widget.user.email,
                style: TextStyle(
                    fontSize: 20, color: Consts.textColor),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ));
  }
}
