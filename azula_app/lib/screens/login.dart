import 'dart:async';
import 'dart:io';


import 'package:azula_app/screens/splash.dart';
import 'package:azula_app/utils/animation.dart';
import 'package:azula_app/utils/random.dart';
import 'package:azula_app/utils/theming.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final Firestore firestore = Firestore.instance;
  StreamSubscription subscription;

  bool googleSignButtonPressed = false;

  Future<FirebaseUser> googleSignIn() async {
    setState(() {
      googleSignButtonPressed = true;
    });
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _signInAuthentication.idToken,
        accessToken: _signInAuthentication.accessToken);
    AuthResult user = await auth.signInWithCredential(credential);
    return user.user;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = FirebaseAuth.instance.onAuthStateChanged.listen((event) {
      if (event != null && event is FirebaseUser) {
        //redirect to login
        setState(() {
          googleSignButtonPressed = false;
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        brightness: Theming.statusBarColor(brightness),
      ),
      backgroundColor: Theming.returnColorDarker(brightness),
      body: Container(
        child: Center(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Azula.',
                    style: TextStyle(
                        color: Theming.returnTextColor(brightness),
                        fontSize: 45,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  RichText(
                      text: TextSpan(children: <TextSpan>[
                    TextSpan(
                      text: "Azula ",
                      style: TextStyle(
                          color: Theming.returnTextColor(brightness),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "Authenticator\n",
                      style: TextStyle(
                          color: Colors.amber,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "v1.1.0(1)",
                      style: TextStyle(
                          color: Theming.returnTextColor(brightness),
                          fontSize: 13),
                    )
                  ])),

                  SizedBox(
                    height: 50,
                  ),

                  // RichText(text: TextSpan(children: <TextSpan>[
                  //   TextSpan(
                  //       text: "Azula is an open project created by Samuel Ezedi, it aims to be technology security provider. The Azula Authenticator will serve as a Two Factor Authenticating technology. The APIs will be made available to everyone to connect and build sdks. Please find my social handles to connect and share.",
                  //     style: TextStyle(fontSize: 14,color: Colors.black)
                  //   )
                  // ])),

                  // Text('Authenticator',style: TextStyle(color: Colors.amber,fontSize: 18,fontWeight: FontWeight.bold),),
                  Expanded(child: Container()),
                  SignInButton(
                    Buttons.Google,
                    onPressed: () async {
                      if (!googleSignButtonPressed) {
                        FirebaseUser u = await googleSignIn();
                        SharedPreferences local = await SharedPreferences.getInstance();
                        QuerySnapshot check = await Firestore.instance.collection('users').where('email', isEqualTo: u.email).getDocuments();

                        if(check.documents.length==0){
                          Firestore.instance.collection('users').add({
                            'email': u.email,
                            'name': u.displayName,
                            'timestamp': Timestamp.now(),
                          });
                        }

                        checkIfAccountAddedWhenLocal(local);

                        setState(() {
                          googleSignButtonPressed = false;
                        });
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      }
                    },
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Text('Connect with me on',
                      style: TextStyle(
                          color: Theming.returnTextColor(brightness))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          icon: Icon(LineIcons.github,
                              color: Theming.returnItemColor(brightness)),
                          onPressed: () async {
                            // launch("https://github.com/samuelezedi");
                          }),
                      IconButton(
                          icon: Icon(
                            LineIcons.twitter,
                            color: Theming.returnItemColor(brightness),
                          ),
                          onPressed: () async {
                            // launch("https://twitter.com/samuelezedi");
                          }),
                      IconButton(
                          icon: Icon(LineIcons.instagram,
                              color: Theming.returnItemColor(brightness)),
                          onPressed: () async {
                            // launch("https://instagram.com/samuelezedi");
                          }),
                    ],
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      // print('here');
                      performWarning();
                    },
                    child: Container(
                      // margin: EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              performWarning();
                            },
                            child: Text(
                              'Continue without login',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              performWarning();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: SamAnimations.shake(
                                begin: -2,
                                end: 2,
                                shakeType: ShakeType.Horizonatally,
                                duration: Duration(milliseconds: 500),
                                child: IconButton(
                                    icon: Icon(LineIcons.arrowRight),
                                    color: Colors.white,
                                    onPressed: () {}),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: googleSignButtonPressed,
                child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: CupertinoActivityIndicator(),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  performWarning() {
    if (!googleSignButtonPressed) {
      var widget;
      if (Platform.isIOS) {
        widget = CupertinoAlertDialog(
          title: Text('Warning'),
          content: Text(
              'Data might be lost when device is misplaced or undergoes reset, are you sure you want to continue without authenticating?'),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              isDefaultAction: false,
              child: new Text("No"),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                String phoneId = generateRandomString(30);
                SharedPreferences session =
                    await SharedPreferences.getInstance();
                session.setString('phoneId', phoneId);
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
              isDefaultAction: false,
              child: new Text("Continue"),
            ),
          ],
        );
      } else {
        widget = AlertDialog(
          title: Text('Warning'),
          content: Text(
              'Data might be lost when device is lost or undergoes reset, are you sure you want to continue without authication?'),
          actions: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },
                child: Text('Yes'))
          ],
        );
      }
      showDialog(
          context: context,
          builder: (context) {
            return widget;
          });
    }
  }

  checkIfAccountAddedWhenLocal(SharedPreferences local) async {
    Firestore fs = Firestore.instance;
    var usr=local.getString('phoneId');
    if(usr != null){
      QuerySnapshot check = await fs.collection('codes').where('userId', isEqualTo: usr).getDocuments();
      if(check.documents.length>0){
        var batch = fs.batch();
        for(int i = 0;i<check.documents.length;i++){
          DocumentSnapshot d = check.documents[i];
          batch.updateData(fs.collection('codes').document(d.documentID), {'userId':user.email});
        }
        batch.commit();
      }
    }
  }
}
