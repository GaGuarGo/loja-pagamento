import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/store.dart';

class StoresManager extends ChangeNotifier {
  StoresManager() {
    _loadStoreList();
    _startTimer();
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Store> stores = [];

  Future<void> _loadStoreList() async {
    loading = true;
    final snapshot = await firestore.collection('stores').get();

    stores = snapshot.docs.map((e) => Store.fromDocument(e)).toList();
    loading = false;
  }

  void _startTimer() {
    Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkOpening();
      notifyListeners();
    });
  }

  void _checkOpening() {
    for (final store in stores) {
      store.updateStatus();
    }
  }
}
