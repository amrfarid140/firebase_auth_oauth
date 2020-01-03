# firebase_auth_oauth

A Flutter plugin that makes it easy to perform OAuth sign in flows using FirebaseAuth. It also includes support for Sign in by Apple for Firebase.
This plugin supports Android, iOS and Web.
OAuth flows are performed by opening pop-up on top of the application to allow the user to authenticate.
However, sign in by Apple for iOS uses the original native flow.


# Usage

**You need to setup Firebase for your project first before using this plugin.**

In your `pubspec.yaml` add

```
dependencies:
  flutter:
    sdk: flutter
  firebase_auth: ^0.15.3
  firebase_core: ^0.4.3+1
  firebase_auth_oauth: ^0.1.0
```

