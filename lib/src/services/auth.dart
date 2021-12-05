// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_database/firebase_database.dart';

import '../config.dart' show box;
import '../globals.dart' show User, API_URL;

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
        email: authResult.user!.email,
        name: authResult.user!.displayName,
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

  Future<bool> storeUser(User user) async {
    try {
      final res = await http.post(
        Uri.parse('$API_URL/users'),
        headers: {'Content-type': 'application/json'},
        body: user.toRawJson(),
      );

      if (res.statusCode == 500) {
        final data = jsonDecode(res.body);
        throw Exception(data['message']);
      }

      return true;
    } catch (e) {
      log(e.toString());
    }

    return false;
  }
}
