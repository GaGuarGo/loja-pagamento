import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/product.dart';

class CheckoutManager extends ChangeNotifier {
  CartManager? cartManager;

  updateCart(CartManager cartManager) {
    this.cartManager = cartManager;
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> checkout() async {
    try {
      await _decrementStock();
    } catch (e, s) {
      log("Erro ao Finalizar Pedido", error: e, stackTrace: s);
    }
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

  Future<void> _decrementStock() async {
    return firestore.runTransaction((t) async {
      final List<Product> productsToUpdate = [];
      final List<Product> productsWithoutStock = [];

      for (final cartProduct in cartManager!.items) {
        Product product;

        if (productsToUpdate.any((p) => p.id == cartProduct.productId)) {
          product =
              productsToUpdate.firstWhere((p) => p.id == cartProduct.productId);
        } else {
          final doc =
              await t.get(firestore.doc('products/${cartProduct.productId}'));

          product = Product.fromDocument(doc);
        }

        //Atulizando o estoque disponivel no carrinho
        cartProduct.product = product;

        final size = product.findSize(cartProduct.size!);

        if (size!.stock! - cartProduct.quantity! < 0) {
          productsWithoutStock.add(product);
        } else {
          size.stock = size.stock! - cartProduct.quantity!;
          productsToUpdate.add(product);
        }
      }

      //Verificando se há produtos na transação sem estoque
      if (productsWithoutStock.isNotEmpty) {
        return Future.error(
            '${productsWithoutStock.length} Produto(s) sem Estoque');
      }

      //Atualizando o estoque dos produtos
      for (final product in productsToUpdate) {
        t.update(firestore.doc('products/${product.id}'),
            {'sizes': product.exportSizeList()});
      }
    });
  }
}
