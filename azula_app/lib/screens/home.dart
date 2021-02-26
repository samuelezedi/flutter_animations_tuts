import 'package:azula_app/main.dart';
import 'package:azula_app/models/code-model.dart';
import 'package:azula_app/models/qrdata-model.dart';
import 'package:azula_app/screens/scanner.dart';
import 'package:azula_app/screens/settings.dart';
import 'package:azula_app/screens/splash.dart';
import 'package:azula_app/utils/flash.dart';
import 'package:azula_app/utils/random.dart';
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
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  int _counter = appSettings['time_duration'];
  bool endCounter = false;
  var batch;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initCounter(_counter);
  }

  initCounter(number) {
    if(!endCounter)
    Future.delayed(Duration(seconds: 1), () {
      if (number == appSettings['time_duration']) {
        arrangeNewCode();
      }
      if (number == 1) {
        batch.commit();
      }
      int newNum = number == 0 ? appSettings['time_duration'] : number - 1;
      setState(() {
        _counter = newNum;
      });
      initCounter(newNum);
    });
  }

  arrangeNewCode() async {
    Firestore fs = Firestore.instance;
    String usr = user != null ? user.email : phoneUser;
    QuerySnapshot check = await fs
        .collection('codes')
        .where('userId', isEqualTo: usr)
        .getDocuments();
    if (check.documents.length > 0) {
      batch = fs.batch();
      for (int i = 0; i < check.documents.length; i++) {
        DocumentSnapshot d = check.documents[i];
        String code = generateRandomInt().toString();
        batch.updateData(
            fs.collection('codes').document(d.documentID), {'code': code});
      }
      return batch;
    }
  }

  Future<String> getUser() async {
    FirebaseUser usr = await FirebaseAuth.instance.currentUser();
    if (usr == null) {
      SharedPreferences session = await SharedPreferences.getInstance();
      return session.getString('phoneId');
    } else {
      user = usr;
      return usr.email;
    }
  }

  startCounter(){
    // Firestore.instance
    //     .collection('codes')
    //     .where('userId', isEqualTo: snapshot.data)
    //     .orderBy('timestamp', descending: true)
    //     .snapshots().listen((event) {
    //
    // });
    if(endCounter){
      setState(() {
        endCounter=false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    batch.dispose();
    endCounter=true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
        child: Icon(LineIcons.qrcode),
        onPressed: () async {
          var data = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => Scanner()));
          if (data != null) {
            print(data.code);
            Uri url = Uri.parse(data.code.toString());
            // print(url.queryParameters);
            if(url.queryParameters['issuer']!=null&&url.queryParameters['secret']!=null){
              QrDataModel cd = QrDataModel.fromMap(url.queryParameters);
              saveToDB(cd);
            }
          }
        },
        backgroundColor: Colors.black,
      ),
      backgroundColor: Theming.returnColor(brightness),
      appBar: AppBar(
        backgroundColor: Theming.returnColorDarker(brightness),
        brightness: Theming.statusBarColor(brightness, forDark: true),
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
                color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ])),
        actions: [
          IconButton(
              icon: Icon(Icons.menu_rounded),
              color: Theming.returnItemColor(brightness,
                  colorIfWhite: Colors.black, colorIfDark: Colors.white),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Settings()));
              })
        ],
      ),
      body: FutureBuilder<String>(
          future: getUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == null) {
                return Center(
                  child: Text('Yet to add Account!',style: TextStyle(fontSize:18, color: Theming.returnTextColor(brightness)),),
                );
              } else {
                return StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection('codes')
                      .where('userId', isEqualTo: snapshot.data)
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, sn) {
                    if (sn.hasData) {
                      if (sn.data.documents.length > 0) {
                        // startCounter();
                        return ListView.builder(
                          itemCount: sn.data.documents.length,
                          itemBuilder: (context, index) {
                            CodeModel data = CodeModel.fromDocumentSnapshot(
                                sn.data.documents[index]);
                            return ListTile(
                                contentPadding: EdgeInsets.all(10),
                                dense: true,
                                title: Text(
                                  data.owner!=""? "${data.issuer} (${data.owner})":"${data.issuer}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color:
                                          Theming.returnTextColor(brightness)),
                                ),
                                subtitle: Text(
                                  "${data.code}",
                                  style: TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 4.1,
                                      color: Colors.amber),
                                ),
                                trailing: CircleAvatar(
                                  backgroundColor: Colors.black,
                                  child: Text(
                                    _counter.toString(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ));
                          },
                        );
                      } else {
                        return Center(
                          child: Text('Yet to add Account!',style: TextStyle(fontSize:18, color: Theming.returnTextColor(brightness)),),
                        );
                      }
                    } else {
                      return Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                  },
                );
              }
            } else {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
          }),
    );
  }

  saveToDB(QrDataModel cd) async {
    String thisUser = user != null ? user.email : phoneUser;
    Firestore fs = Firestore.instance;
    CodeModel data = CodeModel(
      issuer: cd.issuer,
      secret: cd.secret,
      owner: cd.user,
      userId: thisUser,
      code: generateRandomInt().toString(),
      timestamp: Timestamp.now(),
      valid: true,
    );
    QuerySnapshot check = await fs
        .collection('codes')
        .where('issuer', isEqualTo: cd.issuer)
        .where("secret", isEqualTo: cd.secret)
        .where('owner', isEqualTo: cd.user)
        .where('userId', isEqualTo: thisUser)
        .getDocuments();

    if (check.documents.length > 0) {
      //data already exists
      displayMessage(type: 2,message: "Account already exists",scaffoldKey: scaffoldKey);
    } else {
      DocumentReference d =
          await fs.collection('codes').add(CodeModel.toMap(data));
      String code = generateRandomInt().toString();
      batch.updateData(
          fs.collection('codes').document(d.documentID), {'code': code});
    }
  }
}
