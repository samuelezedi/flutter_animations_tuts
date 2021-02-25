import 'package:azula_app/screens/login.dart';
import 'package:azula_app/screens/splash.dart';
import 'package:azula_app/utils/theming.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:line_icons/line_icons.dart';

import '../main.dart';

class Settings extends StatelessWidget {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theming.returnColor(brightness), 
      appBar: AppBar(
        backgroundColor: Theming.returnColor(brightness),
        brightness: Theming.statusBarColor(brightness,forDark: true),
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
        ),
        title: RichText(
            text: TextSpan(children: <TextSpan>[
              TextSpan(
                text: "Azula ",
                style: TextStyle(
                    color: Theming.returnTextColor(brightness),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: "Authenticator",
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),

            ])),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: (){

            },
            leading: Icon(LineIcons.cogs,color: Theming.returnItemColor(brightness),),
            title: Text('Settings',style: TextStyle(color: Theming.returnTextColor(brightness))),
          ),
          ListTile(

            onTap: (){

            },
            leading: Icon(LineIcons.question,color: Theming.returnItemColor(brightness),),
            title: Text('About',style: TextStyle(color: Theming.returnTextColor(brightness))),
          ),
          user != null ? ListTile(

            onTap: () async {
              await _googleSignIn.signOut();
              user = null;
              await auth.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
            },
            leading: Icon(LineIcons.lock,color: Theming.returnItemColor(brightness),),
            title: Text('Logout',style: TextStyle(color: Theming.returnTextColor(brightness))),
          ) : ListTile(

            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
            },
            leading: Icon(LineIcons.lockOpen,color: Theming.returnItemColor(brightness),),
            title: Text('Login',style: TextStyle(color: Theming.returnTextColor(brightness))),
          ),

        ],
      ),
    );
  }
}
