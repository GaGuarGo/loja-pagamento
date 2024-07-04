import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_manager.dart';

class CheckoutManager extends ChangeNotifier {
  CartManager? cartManager;

  updateCart(CartManager cartManager) {
    this.cartManager = cartManager;
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void checkout() {
    _decrementStock();

    _getOrderId().then((value) => print(value));
  }

  Future<int> _getOrderId() async {
    final ref = firestore.doc('aux/ordercounter');

    try {
      final result = await firestore.runTransaction((t) async {
        final doc = await t.get(ref);
        final orderId = doc.get('current') as int;
        await t.update(ref, {'current': orderId + 1});
        return {'orderId': orderId};
      });
      return result['orderId']!;
    } catch (e, s) {
      log('Erro ao Recupera id do Pedido: ', error: e, stackTrace: s);
      return Future.error('Falha ao gerar número do pedido.');
    }
  }

  void _decrementStock() {}
}
