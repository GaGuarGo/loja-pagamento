import 'package:credit_card_type_detector/credit_card_type_detector.dart';

class CreditCard {
  String? number;
  String? holder;
  String? experationDate;
  String? securityCode;
  String? brand;

  void setHolder(String name) => holder = name;
  void setExpirationDate(String date) => experationDate = date;
  void setCVV(String cvv) => securityCode = cvv;
  void setNumber(String number) {
    this.number = number;
    brand = detectCCType(number.replaceAll(' ', '')).single.toString();
  }

  @override
  String toString() {
    return 'CreditCard{number=$number, holder=$holder, experationDate=$experationDate, securityCode=$securityCode, brand=$brand}';
  }
}
