import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';

class AuthSerice {
  final _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithCredential(AuthCredential credential) =>
      _auth.signInWithCredential(credential);

  Future<Void> logout() => _auth.signOut();
  Stream<User> get currentUser => _auth.authStateChanges();
}
