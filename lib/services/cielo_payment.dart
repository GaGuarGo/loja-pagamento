import 'package:cloud_functions/cloud_functions.dart';
import 'package:loja_virtual/models/credit_card.dart';
import 'package:loja_virtual/models/user.dart';

class CieloPayment {
  final functions = FirebaseFunctions.instance;

  Future<void> authorize(
      {required CreditCard creditCard,
      required num price,
      required String orderId,
      required UserModel user}) async {
    final dataSale = <String, dynamic>{
      "merchantOrderId": orderId,
      "amount": (price * 100).toInt(),
      "softDescriptor": 'Loja Gabriel',
      "installments": 1,
      "creditCard": creditCard.toJson(),
      "cpf": user.cpf,
      "paymentType": 'CreditCard',
    };

    final callable = functions.httpsCallable('authorizeCreditCard');

    final response = await callable.call(dataSale);
    print(response.data);
  }
}
