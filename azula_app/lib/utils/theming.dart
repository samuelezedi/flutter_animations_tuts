
import 'package:flutter/material.dart';

class Theming{
  static returnColorDarker(brightness, {Color ifDark, Color ifLight}) {
    return brightness == Brightness.dark ? ifDark!=null? ifDark : Color(0xff36393f) : ifLight!=null? ifLight : Colors.white;
  }

  static returnColor(brightness, {Color ifDark, Color ifLight}) {
    return brightness == Brightness.dark ? ifDark!=null? ifDark : Color(0xff4f545c) : ifLight!=null? ifLight : Colors.white;
  }

  static statusBarColor(brightness,{forDark = false}) {
    return forDark ? Brightness.light : brightness == Brightness.dark ? Brightness.dark : Brightness.light;
  }

  static returnTextColor(brightness, {Color specifyColor, Color colorIfDark, Color colorIfWhite}) {
    return specifyColor != null ? specifyColor : brightness == Brightness.dark ? colorIfDark!=null ? colorIfDark : Colors.white : colorIfWhite!=null ? colorIfWhite : Color(0xff36393f);
  }

  static shimmerBaseColor(brightness) {
    return brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[300];
  }

  static shimmerHighlightColor(brightness) {
    return brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[200];
  }

  ///returnItemColor
  ///This returns the opposite of color;
  ///if the device is on dark mode, this returns white and vice versa

  static returnItemColor(brightness, {Color specifyColor, Color colorIfDark, Color colorIfWhite}) {
    return specifyColor != null ? specifyColor : brightness == Brightness.dark ? colorIfDark!=null ? colorIfDark : Colors.white : colorIfWhite!=null ? colorIfWhite : Colors.black;
  }
}