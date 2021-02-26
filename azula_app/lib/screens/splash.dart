
import 'package:azula_app/utils/animation.dart';
import 'package:azula_app/utils/random.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'home.dart';
import 'login.dart';
FirebaseUser user;
String phoneUser;
DocumentSnapshot appSettings;

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
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
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
        // animationController.dispose();
        if (user == null) {
          if(phoneUser!=null){
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Home()));
          } else {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Login()));
          }
        } else {
          Navigator.pushReplacement(
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
    await Future.delayed(Duration(seconds: 1));
    appSettings = await Firestore.instance.collection('app_settings').document('vF0EanG7Jwe9dVVmnFvV').get();
    FirebaseUser usr = await FirebaseAuth.instance.currentUser();

    if(usr==null){
      SharedPreferences local = await SharedPreferences.getInstance();
      if(local.getString('phoneId')!=null){
        phoneUser = local.getString('phoneId');
      } else {
        phoneUser = generateRandomString(13);
        local.setString('phoneId', phoneUser);
      }
    } else{
      user = usr;
    }
    return 1;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
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
                child: SamAnimations.fade(
                  fadeBegin: Colors.amber,
                  fadeEnd: Colors.black,
                  repeat: false,
                  duration: Duration(milliseconds: 500),
                  builder: (context, animation) {
                    return Container(
                        child: Text(
                      'Azula.',
                      style: TextStyle(
                          color: animation.value,
                          fontSize: 45,
                          fontWeight: FontWeight.bold),
                    ));
                  }
                ),
              );
            }
          }),
    );
  }
}

// Text('Azula.',style: TextStyle(color: Colors.black,fontSize: 45,fontWeight: FontWeight.bold),)),
