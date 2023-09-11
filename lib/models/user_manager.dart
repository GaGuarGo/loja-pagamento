// ignore_for_file: avoid_print, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:loja_virtual/helpers/firebase_errors.dart';

import 'user.dart';

class UserManager extends ChangeNotifier {
  UserManager() {
    _loadCurrentUser();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? user;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> signIn(
      {required UserModel user,
      required Function onFail,
      required Function onSuccess}) async {
    loading = true;

    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: user.email!, password: user.password!);

      this.user = result.user;

      onSuccess();
    } on FirebaseAuthException catch (e) {
      //OS NOMES DOS ERROS MUDARAM TEM QUE COLOCAR OS NOVOS
      onFail(getErrorString(e.code));
    }

    loading = false;
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _loadCurrentUser() async {
    final currentUser = _auth.currentUser;

    if (currentUser != null) {
      user = currentUser;
    }
    notifyListeners();
  }
}
