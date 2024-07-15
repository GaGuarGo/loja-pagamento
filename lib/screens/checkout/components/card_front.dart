import 'package:brasil_fields/brasil_fields.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:credit_card_type_detector/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/screens/checkout/components/card_model.dart';
import 'package:loja_virtual/screens/checkout/components/card_text_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CardFront extends StatelessWidget {
  CardFront({super.key});

  final MaskTextInputFormatter dateFormatter = MaskTextInputFormatter(
      mask: '!#/####', filter: {'#': RegExp('[0-9]'), '!': RegExp('[0-1]')});

  final creditCardTypes = [
    CreditCardType.elo,
    CreditCardType.mastercard,
    CreditCardType.visa
  ];

  @override
  Widget build(BuildContext context) {
    return CardModal(
      content: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CardTextField(
                  title: 'Número',
                  hint: '0000 0000 0000 0000',
                  textInputType: TextInputType.number,
                  bold: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CartaoBancarioInputFormatter(),
                  ],
                  validator: (value) {
                    if (value!.length != 19)
                      return 'Inválido';
                    else if (!creditCardTypes.contains(detectCCType(value)))
                      return "Inválido";
                    return null;
                  },
                ),
                CardTextField(
                  title: 'Validade',
                  hint: '12/24',
                  textInputType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    dateFormatter,
                  ],
                  validator: (value) {
                    if (value!.length != 7) return 'Inválido';
                    return null;
                  },
                ),
                CardTextField(
                  title: 'Titular',
                  hint: 'João M da Silva',
                  textInputType: TextInputType.text,
                  bold: true,
                  inputFormatters: [],
                  validator: (value) {
                    if (value!.trim().isEmpty) return 'Inválido';
                    return null;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
