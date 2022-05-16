import 'package:flutter/material.dart';

class Consts {
  static getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static const horoscopeAPIUrl =
      'https://nypost.com/horoscopes/';

  static const zodiacSigns = <String>{"aquarius","pisces","aries","taurus","gemini","cancer","leo","virgo","libra","scorpio","sagittarius","capricorn"};

  static const okStatus = 200;

  static const simpleFont = 'Barlow';
  static const titleFont = 'Cinzel';

  static const bgColor = Color(0xffF0F2FF);
  static const textColor = Color(0xff01023B);
  static const btnColor = Color(0xffBCC2FF);

  static const trueDB = 1;
  static const falseDB = 0;

  static const titles = {"Calm", "Anxious", "Happy", "Sad", "Relax"};


  static const paths = {
    "assets/images/calm.png",
    "assets/images/anxious.png",
    "assets/images/happy.png",
    "assets/images/sad.png",
    "assets/images/relax.png"
  };

  static const pathsRec = {
    "assets/images/moments.jpg",
    "assets/images/productive.jpg",
    "assets/images/rainy.jpg",
    "assets/images/read.jpg",
    "assets/images/chill.jpg"
  };

  static String musicPath = 'assets/music/calm.mp3';
  static String imagePath = pathsRec.elementAt(3);
  static String text = 'Good time to read a book!';

  static int pressedIndex = 0;
}
