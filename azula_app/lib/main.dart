
import 'package:azula_app/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
var brightness = SchedulerBinding.instance.window.platformBrightness;

void main() {

  WidgetsFlutterBinding.ensureInitialized();
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
