import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';

class CartManager {
  List<CartProduct> items = [];

  UserModel? user;

  updateUser(UserManager userManager) {
    user = userManager.user;
    items.clear();

    if (user != null) {
      _loadCartItens();
    }
  }

  Future<void> _loadCartItens() async {
    final cartSnap = await user!.cartReference.get();

    print(cartSnap.docs.length);

    items = cartSnap.docs.map((d) => CartProduct.fromDocument(d)).toList();
  }

  void addToCart(Product product) {
    try {
      final e = items.firstWhere((p) => p.stackable(product));
      e.quantity = e.quantity! + 1;
    } catch (e) {
      final cartProduct = CartProduct.fromProduct(product);
      items.add(cartProduct);
      user!.cartReference.add(cartProduct.toCartItemMap());
    }
  }
}
