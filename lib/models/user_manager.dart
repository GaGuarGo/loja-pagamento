// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/helpers/firebase_errors.dart';

import 'user.dart';

class UserManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signIn(
      {required UserModel user,
      required Function onFail,
      required Function onSuccess}) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: user.email!, password: user.password!);

      onSuccess();
    } on FirebaseAuthException catch (e) {
      //OS NOMES DOS ERROS MUDARAM TEM QUE COLOCAR OS NOVOS
      onFail(getErrorString(e.code));
    }
  }
}
