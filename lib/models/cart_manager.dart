import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/services/cepaberto_service.dart';
import 'package:geolocator/geolocator.dart';

class CartManager extends ChangeNotifier {
  List<CartProduct> items = [];

  UserModel? user;
  Address? address;

  num productsPrice = 0.0;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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

    notifyListeners();
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

  //ADDRESS

  Future<void> getAddress(String cep) async {
    final cepAbertoService = CepAbertoService();

    try {
      final cepApertoAddress = await cepAbertoService.getAddressFromCep(cep);

      if (cepApertoAddress != null) {
        address = Address(
          street: cepApertoAddress.logradouro,
          district: cepApertoAddress.bairro,
          zipCode: cepApertoAddress.cep,
          city: cepApertoAddress.cidade,
          state: cepApertoAddress.estado,
        );
        notifyListeners();
      }
    } catch (e, s) {
      log("Erro ao Carregar CEP", error: e, stackTrace: s);
    }
  }

  void setAddress(Address address) {
    this.address = address;

    //Endereço fixo por causa o cepAberto parou de funcionar no momento
    calculateDelivery(lat: -23.200375017697805, long: -47.29914351386176);
  }

  void removeAddress() {
    address = null;
    notifyListeners();
  }

  Future<void> calculateDelivery(
      {required double lat, required double long}) async {
    final DocumentSnapshot doc = await firestore.doc('aux/delivery').get();

    final latStore = doc['lat'];
    final longStore = doc['long'] as double;

    final maxKM = doc['maxkm'] as num;

    double dist =
        await Geolocator.distanceBetween(latStore, longStore, lat, long);

    dist /= 1000; //KM

    print('Distance $dist');
  }
}
