import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  Animation<Color> animationColor;
  AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    animation = Tween<double>(begin: 20.0, end: 100.0).animate(animationController);
    animationColor = ColorTween(begin: Colors.white, end: Colors.blue,).animate(animationController);

    animation.addListener(() {
      setState(() {
        print(animation.value.toString());
      });
    });

    animation.addStatusListener((status) {
      print(status);
    });

    animationController.forward();

  }
  @override
  Widget build(BuildContext context) {
    return Center(child: Container(
      width: animation.value,
      height: animation.value,
      color: animationColor.value,
      child: FlutterLogo(),
    ));
  }
}
