import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planner/pages/sign_in_page.dart';
import 'package:planner/pages/sign_up_page.dart';

import '../consts/consts.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Consts.bgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Consts.textColor,
                      fixedSize: Size(Consts.getWidth(context), 45)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignInPage()));
                  },
                  child: Text(
                    "Sign in",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?",
                      style: TextStyle(fontSize: 20, color: Consts.textColor)),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()));
                      },
                      child: Text(
                        " Sign up",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Consts.textColor),
                      ))
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
