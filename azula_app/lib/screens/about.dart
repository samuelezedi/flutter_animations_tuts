import 'package:azula_app/utils/theming.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theming.returnColor(brightness),
      appBar: AppBar(
        backgroundColor: Theming.returnColorDarker(brightness),
        brightness: Theming.statusBarColor(brightness, forDark: true),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theming.returnItemColor(brightness),
            size: 15,
          ),
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
                color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ])),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
                text: TextSpan(children: <TextSpan>[
              TextSpan(
                  text:
                      "Azula is an open project created by Samuel Ezedi(samuelezedi@gmail.com), it aims to be technology security provider. The Azula Authenticator will serve as a Two Factor Authenticating technology. The APIs will be made available to everyone to connect and build sdks. Please find my social handles to connect and share.",
                  style: TextStyle(
                      fontSize: 14, color: Theming.returnTextColor(brightness)))
            ])),
          ),
        ],
      ),
    );
  }
}
