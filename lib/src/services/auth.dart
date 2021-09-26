// ignore_for_file: avoid_print
import 'package:google_sign_in/google_sign_in.dart';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_database/firebase_database.dart';

import 'package:catmapp/src/config.dart' show box;
import 'package:catmapp/src/globals.dart' show User;

class Auth {
  static final _instance = Auth();
  static Auth get instance => _instance;

  User? _user;

  final _google = GoogleSignIn();
  final _users = FirebaseDatabase.instance.reference().child('users');

  User? get currentUser => _user;
  bool get isAuth => box.read('user') != null;

  Auth() {
    if (!isAuth) {
      signOut().then((_) => print('signOut')).catchError((err) => print(err));
    } else {
      _user = User.fromRawJson(box.read<String>('user'));
    }
  }

  Future<bool> tryGoogle() async {
    try {
      final account = await _google.signIn();
      final authentication = await account!.authentication;

      final authResult = await fb.FirebaseAuth.instance.signInWithCredential(
        fb.GoogleAuthProvider.credential(
          idToken: authentication.idToken,
          accessToken: authentication.accessToken,
        ),
      );

      final uid = authResult.user!.uid;

      _user = User(
        uid: uid,
        name: authResult.user!.displayName,
        email: authResult.user!.email,
        photoUrl: authResult.user!.photoURL,
        phoneNumber: authResult.user!.phoneNumber,
      );

      await box.write('user', _user!.toRawJson());
      await _users.child(uid).set(_user!.toJson());

      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<void> signOut() async {
    if (await _google.isSignedIn()) {
      await _google.signOut();
    }
    await box.erase();
  }
}
