# firebase_auth_oauth

A Flutter plugin that makes it easy to perform OAuth sign in flows using FirebaseAuth. It also includes support for Sign in by Apple for Firebase.
This plugin supports Android, iOS and Web.
OAuth flows are performed by opening pop-up on top of the application to allow the user to authenticate or the native flow in the case of sign in by apple.


# Usage

**You need to set up Firebase for your project first before using this plugin. Instructions can be found [here](https://firebase.flutter.dev/docs/overview).**

- In your `pubspec.yaml` add

```
dependencies:
  flutter:
    sdk: flutter
  firebase_auth: ^4.1.1
  firebase_core: ^2.1.1
  firebase_auth_oauth: ^1.2.2
```

- Then in your project just call

```

FirebaseUser user = await FirebaseAuthOAuth().openSignInFlow("A provider ID", [list of scopes], {custom parameters map});

// Sign-in by Apple example
User user = await FirebaseAuthOAuth()
          .openSignInFlow("apple.com", ["email"], {"locale": "en"});

// Or you can link an existing logged-in user
User user = await FirebaseAuthOAuth()
          .linkExistingUserWithCredentials("apple.com", ["email"], {"locale": "en"});

// Or if the OAuth credential result is needed, you can fetch provider auth result with one of the following
OAuthCredential credential = await FirebaseAuthOAuth().signInOAuth("apple.com", ["email"], {"locale": "en"});
OAuthCredential credential = await FirebaseAuthOAuth().linkWithOAuth("apple.com", ["email"], {"locale": "en"});
USer user = FirebaseAuth.instance.currentUser;

```
Checkout [the example Widget](https://github.com/amrfarid140/firebase_auth_oauth/blob/main/firebase_auth_oauth/example/lib/main.dart).

# Auth Providers Support

| Name        | Supported           |
| ------------- |:-------------:|
| Apple      | ✅ (Android, Web & iOS 13) |
| Twitter      | ✅      |
| Github | ✅      |
| Microsoft | ✅      |
| Yahoo | ✅      |
| Facebook | 🚫     |

This plugin supports OAuth operations using `OAuthProvider` only with the exception
to Sign in by Apple on iOS 13 where it uses the native `AuthenticationService`.

# Error Handling

Below are the error codes you might receive when using this plugin

| Code        | Meaning           |
| ------------- |:-------------:|
| FirebaseAuthError      | An error coming from `FirebaseAuth` SDK |
| PluginError      | An error coming from this plugin. e.g. Invalid arguments or null items      |
| PlatformError | An error coming from the native platform      |

