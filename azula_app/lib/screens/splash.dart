import 'package:azula_app/screens/home.dart';
import 'package:azula_app/utils/theming.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'login.dart';
FirebaseUser user;

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  Animation<Color> animationColor;
  AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animationColor = ColorTween(
      begin: Colors.white,
      end: Colors.blue,
    ).animate(animationController);

    animation.addListener(() {
      setState(() {});
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (user == null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Login()));
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      }
    });

    // animationController.forward();
    // checkAuthentication(animationController);
  }

  beginAnimation(animationController) async {
    Future.delayed(Duration(milliseconds: 1000), () {
      animationController.forward();
    });
  }

  Future<int> checkAuthentication() async {
    await Future.delayed(Duration(seconds: 4));
    FirebaseUser usr = await FirebaseAuth.instance.currentUser();
    user = usr;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      //   brightness: Theming.statusBarColor(brightness),
      // ),
      backgroundColor: Colors.amber,
      body: FutureBuilder<int>(
          future: checkAuthentication(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              animationController.forward();
              return Center(
                  child: Container(
                child: Transform.scale(
                    scale: animation.value * 50,
                    child: Text(
                      'Azula.',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 45,
                          fontWeight: FontWeight.bold),
                    )),
              ));
              // Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
            } else {
              return Center(
                child: Container(
                    child: Text(
                  'Azula.',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 45,
                      fontWeight: FontWeight.bold),
                )),
              );
            }
          }),
    );
  }
}

// Text('Azula.',style: TextStyle(color: Colors.black,fontSize: 45,fontWeight: FontWeight.bold),)),
