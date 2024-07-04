import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_manager.dart';

class CheckoutManager extends ChangeNotifier {
  CartManager? cartManager;

  updateCart(CartManager cartManager) {
    this.cartManager = cartManager;
  }
}
