import 'dart:convert';
import 'dart:typed_data';

import "package:flutter/cupertino.dart";

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:planner/consts/consts.dart';
import 'package:planner/db/db_helper.dart';
import 'package:planner/models/uploaded_image.dart';
import 'package:planner/models/user.dart';
//import 'package:planner/pages/main_page.dart';
import 'package:planner/pages/sign_in_page.dart';
import 'package:planner/widgets/text_field.dart';
import 'package:crypto/crypto.dart';

import 'main_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmedPasswordController = TextEditingController();
  DateTime date=DateTime.now();

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
                      "Sign up",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Consts.textColor),
                    )),
                Padding(
                  padding: EdgeInsets.only(
                      left: 30, right: 30, top: 40, bottom: 10),
                  child: Column(
                    children: <Widget>[
                      CustomTextField(
                        inputType: TextInputType.text,
                        initialValue: "",
                        label: 'Username*',
                        controller: usernameController,
                        isPasswordField:false,
                      ),

                      CustomTextField(
                        inputType: TextInputType.emailAddress,
                        initialValue: "",
                        label: 'Email*',
                        controller: emailController,
                        isPasswordField: false,
                      ),
                      CustomTextField(
                        inputType: TextInputType.text,
                        initialValue: "",
                        label: 'Password*',
                        controller: passwordController,
                        isPasswordField: true,
                      ),
                      CustomTextField(
                        inputType: TextInputType.text,
                        initialValue: "",
                        label: 'Confirm password*',
                        controller: confirmedPasswordController,
                        isPasswordField: true,
                      )
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
                      if (validate()){
                      User? user = await _checkPasswords();
                      if (user!=null) {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => MainPage(
                                      index: 0,
                                      user: user,
                                    )));
                      } else {
                        _showMessage(context, "Passwords are not the same", "Please, check your input and try again.");
                      }
                    }},
                    child: Text(
                      "Sign up",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?",
                        style: TextStyle(fontSize: 20, color: Consts.textColor)),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInPage()));
                        },
                        child: Text(
                          " Sign in",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Consts.textColor),
                        ))
                  ],
                )
              ],
            ), ));
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
    if (usernameController.text.isEmpty){
      return "Username shouldn't be empty!";
    }
    if (!emailController.text.contains(RegExp(r'(?=.*[@.])'))){
      return "Email must contain \'@\' and \'.\' symbols!";
    }
    if (!passwordController.text.contains(RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{8,}$'))){
      return "Password\'s length must be at least 8 symbols and contains at least one upper and lower case letters and digit!";
    } else {
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

  Future<User?> _checkPasswords() async {

    var hashFirst =
        sha512.convert(utf8.encode(passwordController.text)).toString();
    var hashSecond = sha512
        .convert(utf8.encode(confirmedPasswordController.text))
        .toString();
    if (hashFirst == hashSecond) {
      User user = await _save();
      return user;
    } else {
      return null;
    }
  }

  Future<User> _save() async {

    int id = await DatabaseHelper.instance.getUsersCount() + 1;
    User user = User(
        id: id,
        email: emailController.text,
        username: usernameController.text,
        passwordHash: sha512
            .convert(utf8.encode(confirmedPasswordController.text))
            .toString(),
        isAuthorized: Consts.trueDB,);
    await DatabaseHelper.instance.addUser(user);
    //int imgID = await DatabaseHelper.instance.getImagesCount()+1;
    //UploadedImage img = UploadedImage(id: imgID, bytes: imgBytes, idNote: id,);
   // await DatabaseHelper.instance.addImage(img);
    return user;
  }
}
