
import 'dart:io';

import 'package:azula_app/screens/about.dart';
import 'package:azula_app/screens/login.dart';
import 'package:azula_app/screens/splash.dart';
import 'package:azula_app/utils/theming.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theming.returnColor(brightness), 
      appBar: AppBar(
        backgroundColor: Theming.returnColorDarker(brightness),
        brightness: Theming.statusBarColor(brightness,forDark: true),
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,color: Theming.returnItemColor(brightness),size: 15,),
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
              Navigator.push(context, MaterialPageRoute(builder: (context)=>About()));
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

          Expanded(
            child: Container(),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              IconButton(
                onPressed: ()async{
                  SharedPreferences local = await SharedPreferences.getInstance();
                  var dark =local.getBool('isDark');
                  if(dark!=null){
                    if(dark){
                      brightness = Brightness.dark;
                      local.setBool('isDark', false);
                    } else {
                      brightness = Brightness.light;
                      local.setBool('isDark', true);
                    }
                  } else{
                    if(brightness == Brightness.dark){
                      brightness = Brightness.light;
                      local.setBool('isDark', true);
                    } else{
                      brightness = Brightness.dark;
                      local.setBool('isDark', false);
                    }
                  }
                  setState(() {

                  });
                },
                icon: Icon(LineIcons.lightbulb,color: Theming.returnItemColor(brightness),size: 35,),
              ),
              InkWell(
                onTap: (){

                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Current version "+appSettings.data['version'],style: TextStyle(fontWeight:FontWeight.bold,color: Theming.returnTextColor(brightness)),)
                )
              )
            ]
          ),

          Platform.isIOS?SizedBox(height: 15,):Container()

        ],
      ),
    );
  }
}
