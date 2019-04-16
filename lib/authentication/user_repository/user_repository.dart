import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:homescreen/authentication/authentication.dart';

class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<FirebaseUser> signInWithGoogle(
      AuthenticationBloc authnticationBloc) async {
    authnticationBloc.dispatch(LoggingIn());
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    if (googleUser == null) authnticationBloc.dispatch(LoggedOut());
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _auth.signInWithCredential(credential);
    return _auth.currentUser();
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
