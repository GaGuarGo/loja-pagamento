import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/cart_product.dart';

enum Status { canceled, preparing, transporting, delivered }

class UserOrder {
  UserOrder.fromCartManager(CartManager cartManager) {
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user!.id;
    address = cartManager.address;
    status = Status.preparing;
  }
  UserOrder.fromDocument(QueryDocumentSnapshot doc) {
    orderId = doc.id;

    items = (doc.get('items') as List<dynamic>)
        .map((i) => CartProduct.fromMap(i))
        .toList();

    price = doc.get('price') as num;
    userId = doc.get('user') as String;
    address = Address.fromMap(doc.get('address') as Map<String, dynamic>);
    date = doc.get('date') as Timestamp;
    status = Status.values[doc.get('status')];
  }

  String? orderId;
  List<CartProduct>? items;
  num? price;
  String? userId;
  Address? address;
  Timestamp? date;
  Status? status;

  String get statusText => getStatusText(status!);

  static String getStatusText(Status status) {
    switch (status) {
      case Status.canceled:
        return 'Cancelado';
      case Status.preparing:
        return 'Em preparação';
      case Status.transporting:
        return 'Em transporte';
      case Status.delivered:
        return 'Entregue';
      default:
        return '';
    }
  }

  String get formattedId => '#${orderId!.padLeft(6, '0')}';

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> save() async {
    firestore.collection('orders').doc(orderId).set(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items!.map((i) => i.toOrderItemMap()).toList(),
      'price': price,
      'user': userId,
      'address': address!.toMap(),
      'status': status!.index,
      'date': Timestamp.now(),
    };
  }

  @override
  String toString() {
    return 'UserOrder{orderId=$orderId, items=$items, price=$price, userId=$userId, address=$address, date=$date, firestore=$firestore}';
  }
}
