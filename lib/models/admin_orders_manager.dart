import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_order.dart';

class AdminOrdersManager extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  StreamSubscription? _subscription;

  updateAdmin(bool adminEnabled) {
    _orders.clear();
    _subscription?.cancel();
    if (adminEnabled) {
      _listenToOrders();
    }
  }

  List<UserOrder> _orders = [];
  UserModel? userFilter;
  List<Status> statusFilter = [Status.preparing, Status.canceled];

  void _listenToOrders() {
    _subscription =
        firestore.collection('orders').snapshots().listen((event) async {
      for (final change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            _orders.add(UserOrder.fromDocument(change.doc));
          case DocumentChangeType.modified:
            final modOrder =
                _orders.firstWhere((o) => o.orderId == change.doc.id);
            modOrder.updateFromDocument(change.doc);
          case DocumentChangeType.removed:
        }
      }

      notifyListeners();
    });
  }

  void setStatusFilter({required Status status}) {
    if (statusFilter.contains(status)) {
      statusFilter.remove(status);
    } else {
      statusFilter.add(status);
    }
    notifyListeners();
  }

  List<UserOrder> get filteredOrders {
    List<UserOrder> output = _orders.reversed.toList();

    if (userFilter != null) {
      output = output.where((o) => o.userId == userFilter!.id).toList();
    }

    output = output.where((o) => statusFilter.contains(o.status)).toList();

    return output;
  }

  void setUserFilter(UserModel? user) {
    userFilter = user;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}
