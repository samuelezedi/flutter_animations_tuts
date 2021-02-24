import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session {
  SharedPreferences _local;
  instance()async{
    _local = await SharedPreferences.getInstance();
    return Session;
  }

  putString(String key, String value) {
    return _local.setString(key, value);
  }

  putStringList(String key, List<String> value) {
    return _local.setStringList(key, value);
  }

  getString(String key) {
    return _local.getString(key);
  }

  getStringList(String key) {
    return _local.getStringList(key);
  }

}