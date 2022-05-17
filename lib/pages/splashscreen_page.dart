import 'package:flutter/material.dart';
import 'package:planner/consts/consts.dart';
import 'package:planner/db/db_helper.dart';
import 'package:planner/models/user.dart';
import 'package:planner/pages/welcome_page.dart';
import 'package:splashscreen/splashscreen.dart';

import 'main_page.dart';

class SplashscreenPage extends StatefulWidget {
  const SplashscreenPage({Key? key}) : super(key: key);


  @override
  _SplashscreenPageState createState() => _SplashscreenPageState();
}

class _SplashscreenPageState extends State<SplashscreenPage> {

  Widget widgetNavigate = const WelcomePage();


  Future<Widget> loadPage() async {

    User? user = await DatabaseHelper.instance.findAuthUser();
    if (user==null){
      return const WelcomePage();
    } else{
      return MainPage(index: 0, user: user);
    }
  }

  void initWidget(){
    loadPage().then((value) {
      setState(() {
        widgetNavigate=value;
      });
    });
  }

  @override
  void initState(){
    super.initState();
    initWidget();
  }


  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: widgetNavigate,
      backgroundColor: Consts.bgColor,
      image: Image.asset("assets/icons/logo.png",color: Consts.textColor,colorBlendMode: BlendMode.modulate,
      ),
      photoSize: Consts.getWidth(context)/4,
      loaderColor: Colors.transparent,
    );
  }
}
