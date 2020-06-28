import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo/screens/auth_screen.dart';
import 'package:todo/sharedpref.dart';

class AuthProvider with ChangeNotifier {
  //init google ,facebook ,firebase instance
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fb = FacebookLogin();
  //sign in with google
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    //get the credential
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
//sign in with the credential we get
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    // save user id in sharedPrefrence
    SharedPrefUtil.getInstance().saveData('userid', user.uid);
    //returen userid
    return user.uid;
  }

  Future<String> signInWithFacebook() async {
    // Log in
    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

    switch (res.status) {
      case FacebookLoginStatus.Success:
        //get the access token
        final FacebookAccessToken accessToken = res.accessToken;

        final AuthCredential credential =
            FacebookAuthProvider.getCredential(accessToken: accessToken.token);
        final FirebaseUser user =
            (await _auth.signInWithCredential(credential)).user;
        // save user id in sharedPrefrence
        SharedPrefUtil.getInstance().saveData('userid', user.uid);
        return user.uid;

        break;
      case FacebookLoginStatus.Cancel:
        break;
      case FacebookLoginStatus.Error:
        print('Error while log in: ${res.error}');
        break;
    }
    return null;
  }

  Future<void> signOut(context) async {
    //sign out and delete userid
    await _auth?.signOut();
    await _googleSignIn?.signOut();
    await fb?.logOut();
    SharedPrefUtil.getInstance().deleteDataByKey('userid');
    Navigator.of(context).pushReplacementNamed(AuthScreen.ROUTE_NAME);
  }
}
