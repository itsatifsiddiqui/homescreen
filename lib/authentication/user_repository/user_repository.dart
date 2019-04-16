import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:homescreen/authentication/authentication.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookLogin = FacebookLogin();

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _auth.signInWithCredential(credential);
    return _auth.currentUser();
  }

  Future<FirebaseUser> signInWithFacebook() async {
    final result = await _facebookLogin
        .logInWithReadPermissions(['email', 'public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final accessToken = result.accessToken;
        AuthCredential credential =
            FacebookAuthProvider.getCredential(accessToken: accessToken.token);
        return await _auth.signInWithCredential(credential);
      case FacebookLoginStatus.cancelledByUser:
        return null;
      case FacebookLoginStatus.error:
        return null;
    }

    await Future.delayed(Duration(milliseconds: 10));
    return null;
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _auth.currentUser();
    print(currentUser.email);
    return currentUser != null;
  }

  Future signOut() async {
    return Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<String> getUser() async {
    return (await _auth.currentUser()).email;
  }
}
