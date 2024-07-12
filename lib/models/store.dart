import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/helpers/extensions.dart';
import 'package:loja_virtual/models/address.dart';

enum StoreStatus { closed, open, closing }

class Store {
  Store.fromDocument(DocumentSnapshot doc) {
    name = (doc.get('name') ?? "") as String;
    image = (doc.get('image') ?? "") as String;
    phone = (doc.get('phone') ?? "") as String;
    address = Address.fromMap(doc.get('address') as Map<String, dynamic>);

    opening = (doc.get('opening') as Map<String, dynamic>).map((key, value) {
      final timeString = value as String?;

      if (timeString != null && timeString.isNotEmpty) {
        final splitted = timeString.split(RegExp(r"[:-]"));

        return MapEntry(key, {
          "from": TimeOfDay(
              hour: int.parse(splitted[0]), minute: int.parse(splitted[1])),
          "to": TimeOfDay(
              hour: int.parse(splitted[2]), minute: int.parse(splitted[3])),
        });
      } else {
        return MapEntry(key, null);
      }
    });
    updateStatus();
  }

  String? name;
  String? image;
  String? phone;

  String get cleanPhone => phone!.replaceAll(RegExp(r"[^\d]"), "");

  Address? address;
  Map<String, Map<String, TimeOfDay>?>? opening;

  StoreStatus? status;

  String get addressText =>
      '${address!.street}, ${address!.number}${address!.complement!.isNotEmpty ? ' - ${address!.complement}' : ''} - '
      '${address!.district}, ${address!.city}/${address!.state}';

  String get openingText {
    return 'Seg-Sex: ${formattedPeriod(opening!['monfri'])}\n'
        'Sab: ${formattedPeriod(opening!['saturday'])}\n'
        'Dom: ${formattedPeriod(opening!['sunday'])}';
  }

  String formattedPeriod(Map<String, TimeOfDay>? period) {
    if (period == null || period.isEmpty) return "Fechada";
    return '${period['from']!.formatted()} - ${period['to']!.formatted()}';
  }

  void updateStatus() {
    final weekDay = DateTime.now().weekday;

    Map<String, TimeOfDay>? period;

    if (weekDay >= 1 && weekDay <= 5) {
      period = opening!['monfri'];
    } else if (weekDay == 6) {
      period = opening!['saturday'];
    } else {
      period = opening!['sunday'];
    }

    final now = TimeOfDay.now();

    if (period == null) {
      status = StoreStatus.closed;
    } else if (period['from']!.toMinutes() < now.toMinutes() &&
        period['to']!.toMinutes() - 15 > now.toMinutes()) {
      status = StoreStatus.open;
    } else if (period['from']!.toMinutes() < now.toMinutes() &&
        period['to']!.toMinutes() > now.toMinutes()) {
      status = StoreStatus.closing;
    } else {
      status = StoreStatus.closed;
    }
  }

  String get statusText {
    switch (status) {
      case StoreStatus.closed:
        return 'Fechada';
      case StoreStatus.open:
        return 'Aberta';
      case StoreStatus.closing:
        return 'Fechando';
      default:
        return '';
    }
  }
}
