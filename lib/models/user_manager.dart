// ignore_for_file: avoid_print, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:loja_virtual/helpers/firebase_errors.dart';

import 'user.dart';

class UserManager extends ChangeNotifier {
  UserManager() {
    _loadCurrentUser();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  UserModel? user;

  bool _loading = false;
  bool get loading => _loading;

  bool get isLoggedIn => user != null;

  Future<void> signIn(
      {required UserModel user,
      required Function onFail,
      required Function onSuccess}) async {
    loading = true;

    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: user.email!, password: user.password!);

      _loadCurrentUser(firebaseUser: result.user);

      onSuccess();
    } on FirebaseAuthException catch (e) {
      //OS NOMES DOS ERROS MUDARAM TEM QUE COLOCAR OS NOVOS
      onFail(getErrorString(e.code));
    }

    loading = false;
  }

  void facebookLogin() {
    
  }

  Future<void> signUp(
      {required UserModel user,
      required Function onFail,
      required Function onSuccess}) async {
    loading = true;

    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: user.email!, password: user.password!);

      user.id = result.user!.uid;
      this.user = user;

      await user.saveData();
      await user.saveToken();

      onSuccess();
    } on FirebaseAuthException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  void signOut() {
    _auth.signOut();
    user = null;
    notifyListeners();
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _loadCurrentUser({User? firebaseUser}) async {
    final currentUser = firebaseUser ?? _auth.currentUser;

    if (currentUser != null) {
      final userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();
      user = UserModel.fromDocument(userDoc);

      user!.saveToken();

      final docAdmin =
          await _firestore.collection('admins').doc(user?.id).get();
      if (docAdmin.exists) {
        user!.admin = true;
      }

      notifyListeners();
    }
  }

  bool get adminEnabled => user != null && user!.admin;
}
