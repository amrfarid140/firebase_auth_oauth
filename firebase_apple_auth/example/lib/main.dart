import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:firebase_apple_auth/firebase_apple_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Future<void> initPlatformState() async {
    try {
      await FirebaseAppleAuth().openSignInFlow();
    } on PlatformException {
      debugPrint("Oh shit");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Center(
              child: Text('Running on fumes\n'),
            ),
            Padding(
              padding: EdgeInsets.all(10),

              child: StreamBuilder(
                  initialData: null,
                  stream: FirebaseAuth.instance.onAuthStateChanged,
                  builder: (BuildContext context,
                      AsyncSnapshot<FirebaseUser> snapshot) {
                    return RaisedButton(
                      onPressed: () async {
                        if(snapshot.data != null) {
                          await FirebaseAuth.instance.signOut();
                        } else {
                          await initPlatformState();
                        }
                      },
                      child: Text(snapshot.data != null ? "Logout" : "Login"),
                    );
                  }),

            )
          ],
        ),
      ),
    );
  }
}
