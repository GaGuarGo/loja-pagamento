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
    _subscription =
        firestore.collection('orders').snapshots().listen((event) async {
      for (final change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            orders.add(UserOrder.fromDocument(change.doc));
          case DocumentChangeType.modified:
            final modOrder =
                orders.firstWhere((o) => o.orderId == change.doc.id);
            modOrder.updateFromDocument(change.doc);
          case DocumentChangeType.removed:
        }
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
