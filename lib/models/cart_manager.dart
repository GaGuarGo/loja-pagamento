import 'package:flutter/foundation.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';

class CartManager extends ChangeNotifier {
  List<CartProduct> items = [];

  UserModel? user;

  num productsPrice = 0.0;

  updateUser(UserManager userManager) {
    user = userManager.user;
    items.clear();

    if (user != null) {
      _loadCartItens();
    }
  }

  Future<void> _loadCartItens() async {
    final cartSnap = await user!.cartReference.get();
    items = cartSnap.docs
        .map((d) => CartProduct.fromDocument(d)..addListener(_onItemUpdated))
        .toList();
  }

  void addToCart(Product product) {
    try {
      final e = items.firstWhere((p) => p.stackable(product));
      e.increment();
    } catch (e) {
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_onItemUpdated);
      items.add(cartProduct);
      user!.cartReference
          .add(cartProduct.toCartItemMap())
          .then((doc) => cartProduct.id = doc.id);
      _onItemUpdated();
    }
    notifyListeners();
  }

  void removeFromCart(CartProduct cartProduct) {
    items.removeWhere((cp) => cp.id == cartProduct.id);
    user!.cartReference.doc(cartProduct.id).delete();
    cartProduct.removeListener(_onItemUpdated);
    notifyListeners();
  }

  void _onItemUpdated() {
    productsPrice = 0.0;

    for (int i = 0; i < items.length; i++) {
      final cartProduct = items[i];

      if (cartProduct.quantity == 0) {
        removeFromCart(cartProduct);
        i--;
        continue;
      }

      productsPrice += cartProduct.totalPrice;

      _updateCartProduct(cartProduct);
    }

    print(productsPrice);
  }

  void _updateCartProduct(CartProduct cartProduct) {
    if (cartProduct.id != null) {
      user!.cartReference
          .doc(cartProduct.id)
          .update(cartProduct.toCartItemMap());
    }
  }

  bool get isCartValid {
    for (final cp in items) {
      if (!cp.hasStock) return false;
    }
    return true;
  }
}
