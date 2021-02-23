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
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 3500));
    animation = CurvedAnimation(parent: animationController, curve: Curves.bounceOut);
    animationColor = ColorTween(begin: Colors.white, end: Colors.blue,).animate(animationController);



    animation.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        animationController.reverse();
      } else if(status == AnimationStatus.dismissed){
        animationController.forward();
      }
    });

    animationController.forward();

  }
  @override
  Widget build(BuildContext context) {
    return Center(child: Container(
     child: AnimatedLogo(animation: animation,),
    ));
  }
}

class AnimatedLogo extends AnimatedWidget {
  AnimatedLogo({Key key, Animation animation})
  : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Transform.scale(
      scale: animation.value*50,
      child: FlutterLogo()


    );
  }
}