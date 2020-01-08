# firebase_auth_oauth

A Flutter plugin that makes it easy to perform OAuth sign in flows using FirebaseAuth. It also includes support for Sign in by Apple for Firebase.
This plugin supports Android, iOS and Web.
OAuth flows are performed by opening pop-up on top of the application to allow the user to authenticate or the native flow in the case of sign in by apple.


# Usage

**You need to setup Firebase for your project first before using this plugin.**

- In your `pubspec.yaml` add

```
dependencies:
  flutter:
    sdk: flutter
  firebase_auth: ^0.15.3
  firebase_core: ^0.4.3+1
  firebase_auth_oauth: ^0.1.0
```

- Then in your project just call

```

FirebaseUser user = await FirebaseAuthOAuth().openSignInFlow("A provider ID", [list of scopes], {custom parameters map});

// Sign-in by Apple example

FirebaseUser user = await FirebaseAuthOAuth()
          .openSignInFlow("apple.com", ["email"], {"locale": "en"});

```

Also Checkout [the example Widget](https://github.com/amrfarid140/firebase_auth_oauth/blob/master/firebase_auth_oauth/example/lib/main.dart).
