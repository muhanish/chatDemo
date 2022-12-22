import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  UserCredential? firebaseUser;
  User? _user;

  User? get user => firebaseUser?.user;

  // Stream<User?> get userStream {
  //   return FirebaseAuth.instance.authStateChanges();
  // }

  Future<bool> signInWithEmailandPass(String email, String pass) async {
    try {
      firebaseUser = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } on Exception catch (e) {
      print('Exception occured at signIn method');
      print(e.toString());
    }

    // AuthCredential? userCredential  = firebaseUser!.credential;
    // firebaseUser.user.uid

    if (firebaseUser != null) {
      print(
          'FROM SIGN IN E & P: firebaseUser.credential:  ${firebaseUser!.credential}');
      print('FROM SIGN IN E & P: firebaseUser.user:  ${firebaseUser!.user}');

      _user = firebaseUser!.user;
      print('FROM SIGN IN E & P: _user:  ${_user}');

      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  Future<bool> creatUser(String email, String password) async {
    UserCredential? firebaseUser;

    try {
      firebaseUser = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on Exception catch (e) {
      // TODO
      print('Exception occured at login method');
      print(e.toString());
    }

    if (firebaseUser != null) {
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }
}
