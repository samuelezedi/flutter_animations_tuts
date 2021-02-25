
import 'package:azula_app/main.dart';
import 'package:azula_app/screens/settings.dart';
import 'package:azula_app/screens/splash.dart';
import 'package:azula_app/utils/theming.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  Future<String> getUser()async{
    FirebaseUser usr = await FirebaseAuth.instance.currentUser();
    if(usr == null){
      SharedPreferences session = await SharedPreferences.getInstance();
      return session.getString('phoneId');
    } else {
      user = usr;
      return usr.email;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(LineIcons.qrcode),
          onPressed: () {},
          backgroundColor: Colors.black,
        ),
        backgroundColor: Theming.returnColor(brightness),
        appBar: AppBar(
          backgroundColor: Theming.returnColorDarker(brightness),
          brightness: Theming.statusBarColor(brightness,forDark: true),
          automaticallyImplyLeading: false,
          centerTitle: true,
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
          actions: [
            IconButton(icon: Icon(Icons.menu_rounded), color: Theming.returnItemColor(brightness,colorIfWhite: Colors.black12,colorIfDark: Colors.white),onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Settings()));
            })
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 40,
            ),

            SizedBox(height: 10,),
            FutureBuilder<String>(
              future: getUser(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  if(snapshot.data!=null){
                    return Text('Yet to add Account!');
                  } else {
                    return StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance.collection('codes').where('user', isEqualTo: snapshot.data).snapshots(),
                        builder: (context,sn){
                          if(sn.hasData){
                            if(sn.data.documents.length>0){
                              return ListView.builder(
                                itemCount: sn.data.documents.length,
                                itemBuilder: (context, index){
                                  return ListTile(
                                    title: Text('sdfd'),
                                  );
                                },
                              );
                            } else{
                              return Center(
                                child: Text('Yet to add Account!'),
                              );
                            }
                          }else{
                            return Center(
                              child: CupertinoActivityIndicator(),
                            );
                          }
                        },

                    );
                  }
                } else{
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                }

              }
            ),
          ],
        ));
  }
}
