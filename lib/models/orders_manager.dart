import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/models/user_order.dart';

class OrdersManager extends ChangeNotifier {
  UserModel? user;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  updateUser(UserManager userManager) {
    user = userManager.user;
    if (user != null) {
      _listenToOrders();
    }
  }

  List<UserOrder> orders = [];

  void _listenToOrders() {
    firestore
        .collection('orders')
        .where('user', isEqualTo: user!.id)
        .snapshots()
        .listen((event) async {
      orders.clear();
      for (final doc in event.docs) {
        orders.add(UserOrder.fromDocument(doc));
      }

      print(orders);
    });
  }
}
