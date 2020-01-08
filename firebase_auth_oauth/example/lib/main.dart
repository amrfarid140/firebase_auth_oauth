import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Future<void> performSignIn() async {
    try {
      await FirebaseAuthOAuth()
          .openSignInFlow("apple.com", ["email"], {"locale": "en"});
    } on PlatformException {
      debugPrint("error logging in");
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
              child: Text('Running example'),
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
                        if (snapshot.data != null) {
                          await FirebaseAuth.instance.signOut();
                        } else {
                          await performSignIn();
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
