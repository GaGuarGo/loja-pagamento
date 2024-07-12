import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/store.dart';

class StoresManager extends ChangeNotifier {
  StoresManager() {
    _loadStoreList();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Store> stores = [];

  Future<void> _loadStoreList() async {
    final snapshot = await firestore.collection('stores').get();

    stores = snapshot.docs.map((e) => Store.fromDocument(e)).toList();
    notifyListeners();
  }
}
