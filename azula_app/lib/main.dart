
import 'package:azula_app/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
var brightness = SchedulerBinding.instance.window.platformBrightness;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences local = await SharedPreferences.getInstance();
  var dark =local.getBool('isDark');
  if(dark!=null){
    if(dark){
      brightness = Brightness.dark;
    } else {
      brightness = Brightness.light;
    }
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Azula',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      fontFamily: 'MavenPro',
        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Splash(),
    );
  }
}
