import 'dart:collection';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/credit_card.dart';
import 'package:loja_virtual/models/user.dart';

class CieloPayment {
  final functions = FirebaseFunctions.instance;

  Future<String> authorize(
      {required CreditCard creditCard,
      required num price,
      required String orderId,
      required UserModel user}) async {
    try {
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
      final data = Map<String, dynamic>.from(response.data as LinkedHashMap);
      if (data['success'] as bool) {
        return data['paymentId'] as String;
      } else {
        debugPrint(data['error']['message']);
        return Future.error(data['error']['message']);
      }
    } catch (e) {
      debugPrint('$e');
      return Future.error('Falha ao Processar Transação. Tente Novamente');
    }
  }

  Future<void> capture(String payId) async {
    final captureData = <String, dynamic>{'payId': payId};

    final callable = functions.httpsCallable('captureCreditCard');
    final response = await callable.call(captureData);
    final data = Map<String, dynamic>.from(response.data as LinkedHashMap);
    if (data['success'] as bool) {
      debugPrint("Pagamento Processado com Sucesso!");
    } else {
      debugPrint(data['error']['message']);
      return Future.error(data['error']['message']);
    }
  }

  Future<void> cancel(String payId) async {
    final Map<String, dynamic> cancelData = {'payId': payId};
    final HttpsCallable callable = functions.httpsCallable('cancelCreditCard');
    final response = await callable.call(cancelData);
    final data = Map<String, dynamic>.from(response.data as LinkedHashMap);

    if (data['success'] as bool) {
      debugPrint('Cancelamento realizado com sucesso');
    } else {
      debugPrint('${data['error']['message']}');
      return Future.error(data['error']['message']);
    }
  }
}
