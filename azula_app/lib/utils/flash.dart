import 'package:flutter/material.dart';

displayMessage({type, message, scaffoldKey}) {
  // showMessage
  scaffoldKey?.currentState?.showSnackBar(SnackBar(
    content: Text(
      message,
      style: TextStyle(
          color: type == 3 ? Colors.black : Colors.white
      ),
    ),
    backgroundColor: type == 2 ? Colors.red : type == 3 ? Colors.amber : Colors.green ,
  ));
}