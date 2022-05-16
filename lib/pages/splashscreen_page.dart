import 'package:flutter/material.dart';
import 'package:planner/consts/consts.dart';
import 'package:planner/models/user.dart';
//import 'package:planner/pages/main_page.dart';
import 'package:planner/pages/welcome_page.dart';
import 'package:splashscreen/splashscreen.dart';

import 'main_page.dart';

class SplashscreenPage extends StatefulWidget {
  const SplashscreenPage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _SplashscreenPageState createState() => _SplashscreenPageState();
}

class _SplashscreenPageState extends State<SplashscreenPage> {

  Widget widgetNavigate = const WelcomePage();
  

  Widget loadPage() {
    if (widget.user.id==-1){
      return const WelcomePage();
    } else{
      return MainPage(index: 0, user: widget.user);
    }
  }

  void initWidget(){
    widgetNavigate=loadPage();
  }

  @override
  void initState(){
    initWidget();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: widgetNavigate,
      backgroundColor: Consts.bgColor,
      image: Image.asset("assets/icons/logo.png",color: Consts.textColor,colorBlendMode: BlendMode.modulate,
      ),
      photoSize: Consts.getWidth(context)/3,
      loaderColor: Colors.transparent,
    );
  }
}
