import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';

class AdminUsersManager extends ChangeNotifier {
  List<UserModel> users = [];

  final _firestore = FirebaseFirestore.instance;

  StreamSubscription? _subscription;

  void updateUser(UserManager userManager) {
    _subscription?.cancel();
    if (userManager.adminEnabled) {
      _listenToUsers();
    } else {
      users.clear();
      notifyListeners();
    }
  }

  void _listenToUsers() {
    //Código para atualizar em tempo real
    /*
 _subscription = _firestore.collection('users').snapshots().listen((snapshot) {
      users = snapshot.docs.map((e) => UserModel.fromDocument(e)).toList();
      users.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      notifyListeners();
    });
    */

    _firestore.collection('users').get().then((snapshot) {
      users = snapshot.docs.map((e) => UserModel.fromDocument(e)).toList();
      users.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      notifyListeners();
    });
  }

  List<String> get names => users.map((e) => e.name!).toList();

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
