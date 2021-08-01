import 'package:flutter/material.dart';

class AppTheme{
static Color blue = const Color.fromRGBO(76, 134, 180,1);
static Color lightblue = const Color.fromRGBO(178, 203, 227,1);
  //Colors
  static Color primaryColor=Colors.blueGrey;
  static Color creditColor=Colors.grey[200];
  static Color debitColor=Colors.grey[300];
  static Color balanceColor=blue;

  //Icon colors
  static Color deleteColor= blue;
  static Color generalIconColor=primaryColor;

  //Fonts style
  static TextStyle userStyle=TextStyle(
    fontSize: 18,
    color: primaryColor,
    fontWeight: FontWeight.bold
  );

  static TextStyle generalTextStyle=TextStyle(
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.w400
  );
  static TextStyle bottomTextStyle=TextStyle(
    fontSize: 10,
    color: Colors.black,
    fontWeight: FontWeight.w400
  );


  //Padding and margins
  static const double generalOutSpacing=20.0;
  static const double smallSpacing=7.0;

  //Item height and width
  static const double listItemHeight=150;
}