import 'package:flutter/material.dart';
import 'package:planner/pages/splashscreen_page.dart';

import 'db/db_helper.dart';
import 'models/user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  User user = User(
      id: -1,
      username: "",
      email: "",
      passwordHash: "",
      isAuthorized: 0,);

  Future<User?> getAuthUser() async {
    User? user = await DatabaseHelper.instance.findAuthUser();
    if (user != null) {
      return user;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    getAuthUser().then((value) => MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashscreenPage(user: value ?? user),
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashscreenPage(user: user),
    );
  }
}
