import 'dart:async';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<void> performLogin(String provider, List<String> scopes,
      Map<String, String> parameters) async {
    try {
      await FirebaseAuthOAuth().openSignInFlow(provider, scopes, parameters);
    } on PlatformException catch (error) {
      /**
       * The plugin has the following error codes:
       * 1. FirebaseAuthError: FirebaseAuth related error
       * 2. PlatformError: An platform related error
       * 3. PluginError: An error from this plugin
       */
      debugPrint("${error.code}: ${error.message}");
    }
  }

  Future<void> performLink(String provider, List<String> scopes,
      Map<String, String> parameters) async {
    try {
      await FirebaseAuthOAuth()
          .linkExistingUserWithCredentials(provider, scopes, parameters);
    } on PlatformException catch (error) {
      /**
       * The plugin has the following error codes:
       * 1. FirebaseAuthError: FirebaseAuth related error
       * 2. PlatformError: An platform related error
       * 3. PluginError: An error from this plugin
       */
      debugPrint("${error.code}: ${error.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: StreamBuilder(
              initialData: null,
              stream: FirebaseAuth.instance.userChanges(),
              builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                return Column(
                  children: [
                    Center(
                      child: Text(
                          snapshot.data == null ? "Logged out" : "Logged In"),
                    ),
                    if (snapshot.data == null ||
                        snapshot.data?.isAnonymous == true) ...[
                      ElevatedButton(
                        onPressed: () async {
                          await performLogin(
                              "apple.com", ["email"], {"locale": "en"});
                        },
                        child: Text("Sign in By Apple"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await performLogin(
                              "twitter.com", ["email"], {"lang": "en"});
                        },
                        child: Text("Sign in By Twitter"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await performLogin(
                              "github.com", ["user:email"], {"lang": "en"});
                        },
                        child: Text("Sign in By Github"),
                      )
                    ],
                    if (snapshot.data != null) ...[
                      ElevatedButton(
                        onPressed: () async {
                          await performLink(
                              "apple.com", ["email"], {"locale": "en"});
                        },
                        child: Text("Link Sign in By Apple"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await performLink(
                              "twitter.com", ["email"], {"lang": "en"});
                        },
                        child: Text("Link Sign in By Twitter"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await performLink(
                              "github.com", ["user:email"], {"lang": "en"});
                        },
                        child: Text("Link Sign in By Github"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                        },
                        child: Text("Logout"),
                      )
                    ]
                  ],
                );
              })),
    );
  }
}
