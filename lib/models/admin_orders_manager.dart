import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_order.dart';

class AdminOrdersManager extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  StreamSubscription? _subscription;

  updateAdmin(bool adminEnabled) {
    orders.clear();
    _subscription?.cancel();
    if (adminEnabled) {
      _listenToOrders();
    }
  }

  List<UserOrder> orders = [];

  void _listenToOrders() {
    _subscription = firestore
        .collection('orders')
        .snapshots()
        .listen((event) async {
      orders.clear();
      for (final doc in event.docs) {
        orders.add(UserOrder.fromDocument(doc));
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}
