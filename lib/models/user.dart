import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/address.dart';

class UserModel {
  UserModel({this.email, this.password, this.name, this.id});

  UserModel.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document['name'] as String;
    email = document['email'] as String;
    cpf = (document['cpf'] ?? "") as String;
    if ((document.data() as Map<String, dynamic>).containsKey('address')) {
      address =
          Address.fromMap(document.get('address') as Map<String, dynamic>);
    }
  }

  String? id;
  String? name;
  String? email;
  String? cpf;
  String? password;

  String? confirmPassword;

  bool admin = false;

  Address? address;

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc('users/$id');

  CollectionReference get cartReference => firestoreRef.collection('cart');

  Future<void> saveData() async {
    await firestoreRef.set(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      if (address != null) 'address': address?.toMap(),
      if (cpf != null) 'cpf': cpf,
    };
  }

  void setAddress(Address address) {
    this.address = address;
    saveData();
  }

  void setCpf(String cpf) {
    this.cpf = cpf;
    saveData();
  }
}
