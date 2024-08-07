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
  num? deliveryPrice;
  num get totalPrice => productsPrice + (deliveryPrice ?? 0);

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  updateUser(UserManager userManager) {
    user = userManager.user;
    productsPrice = 0.0;
    items.clear();
    removeAddress();

    if (user != null) {
      _loadCartItens();
      _loadUserAddress();
    }
  }

  Future<void> _loadCartItens() async {
    final cartSnap = await user!.cartReference.get();
    items = cartSnap.docs
        .map((d) => CartProduct.fromDocument(d)..addListener(_onItemUpdated))
        .toList();
  }

  Future<void> _loadUserAddress() async {
    if (user?.address != null &&
        await calculateDelivery(
            lat: -23.200375017697805, long: -47.29914351386176)) {
      address = user!.address;
      notifyListeners();
    }
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

  void clear() {
    for(final cartProduct in items){
      user!.cartReference.doc(cartProduct.id).delete();
    }
    items.clear();
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

  bool get isAddressValid => address != null && deliveryPrice != null;

  //ADDRESS

  Future<void> getAddress(String cep) async {
    final cepAbertoService = CepAbertoService();

    loading = true;

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
      }

      loading = false;
    } catch (e, s) {
      loading = false;
      log("Erro ao Carregar CEP", error: e, stackTrace: s);
      return Future.error("CEP Inválido");
    }
  }

  Future<void> setAddress(Address address) async {
    loading = true;

    this.address = address;

    //Endereço fixo por causa o cepAberto parou de funcionar no momento
    if (await calculateDelivery(
        lat: -23.200375017697805, long: -47.29914351386176)) {
      user?.setAddress(address);

      loading = false;
    } else {
      loading = false;
      return Future.error('Endereço fora do raio de entrega :(');
    }
  }

  void removeAddress() {
    address = null;
    deliveryPrice = null;
    notifyListeners();
  }

  Future<bool> calculateDelivery(
      {required double lat, required double long}) async {
    final DocumentSnapshot doc = await firestore.doc('aux/delivery').get();

    final latStore = doc['lat'];
    final longStore = doc['long'] as double;

    final base = doc.get('base') as num;
    final km = doc.get('km') as num;
    final maxKM = doc['maxkm'] as num;

    double dist =
        await Geolocator.distanceBetween(latStore, longStore, lat, long);

    dist /= 1000; //KM

    debugPrint('Distance $dist');

    if (dist > maxKM) {
      return false;
    }

    deliveryPrice = base + dist * km;
    return true;
  }
}
