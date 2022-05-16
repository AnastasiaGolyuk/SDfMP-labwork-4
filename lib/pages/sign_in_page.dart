import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planner/consts/consts.dart';
import 'package:planner/db/db_helper.dart';
import 'package:planner/models/user.dart';
import 'package:planner/pages/main_page.dart';
import 'package:planner/pages/sign_up_page.dart';
import 'package:planner/widgets/text_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        backgroundColor: Consts.bgColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Consts.bgColor,
          shadowColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Consts.textColor,
            ),
          ),
        ),
        body: SingleChildScrollView(
        child:
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      "Sign in",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Consts.textColor),
                    )),
                Padding(
                  padding: EdgeInsets.only(
                      left: 30, right: 30, top: 100, bottom: 10),
                  child: Column(
                    children: <Widget>[
                      CustomTextField(inputType: TextInputType.emailAddress,initialValue: "",label: 'Email', controller: emailController, isPasswordField: false),
                      CustomTextField(inputType: TextInputType.text,initialValue: "",label: 'Password', controller: passwordController, isPasswordField: true,)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Consts.textColor,
                        fixedSize: Size(Consts.getWidth(context), 50)),
                    onPressed: () async {
                      if (validate()) {
                        var exist = await _checkUser();
                        if (exist) {
                          bool res = await _checkPasswordHash();
                          if (res) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MainPage(index: 0, user: _user,)));
                          } else {
                            _showMessage(context, "Passwords are not the same!",
                                "Please, check your input and try again.");
                          }
                        }
                      }
                  },
                    child: Text(
                      "Sign in",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
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
        )));
  }

  void _showMessage(BuildContext context, String message, String content) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              message,
              style: TextStyle(
                  fontSize: 18,),
            ),
            content: Text(
              content, style: TextStyle(fontSize: 15),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'Ok'),
                child: Text(
                  'Ok',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          );
        });
  }

  String checkFields(){
    if (!emailController.text.contains(RegExp(r'(?=.*[@.])'))){
      return "Email must contain \'@\' and \'.\' symbols!";
    }
    else {
      return "";
    }
  }

  bool validate(){
    String error = checkFields();
    if (error!=""){
      _showMessage(context, "Validation error", error);
      return false;
    }
    return true;
  }

  late User _user;

  Future<bool> _checkUser() async {
    User? user = await DatabaseHelper.instance.findUser(emailController.text);
    if (user!=null){
      setState(() {
        _user=user;
      });
      return true;
    } else {
      _showMessage(context, "User with this email doesn't exist!", "Check your input or sign up with this email.");
      return false;
    }
  }

  Future<bool> _checkPasswordHash() async{
      return _user.passwordHash==sha512.convert(utf8.encode(passwordController.text)).toString();
  }

}
