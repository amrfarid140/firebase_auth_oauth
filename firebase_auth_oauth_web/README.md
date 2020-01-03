# firebase_auth_oauth_web

Web implementation for `firebase_auth_oauth`

## Usage

### Import the package

To use this plugin in your Flutter app on the web, simply add the base `firebase_auth_oauth` package as a
dependency in your `pubspec.yaml`

### Updating `index.html`

Due to [this bug in dartdevc][2], you will need to manually add the Firebase
JavaScript files to your `index.html` file.

In your app directory, edit `web/index.html` to add the line:

```html
<html>
    ...
    <body>
        <script src="https://www.gstatic.com/firebasejs/7.5.0/firebase-app.js"></script>
        <script src="https://www.gstatic.com/firebasejs/7.5.0/firebase-auth.js"></script>
        <script src="main.dart.js"></script>
    </body>
</html>
```
