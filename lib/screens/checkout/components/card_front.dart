import 'package:brasil_fields/brasil_fields.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:credit_card_type_detector/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/models/credit_card.dart';
import 'package:loja_virtual/screens/checkout/components/card_model.dart';
import 'package:loja_virtual/screens/checkout/components/card_text_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CardFront extends StatelessWidget {
  final CreditCard creditCard;
  final FocusNode numberFocus;
  final FocusNode dateFocus;
  final FocusNode nameFocus;
  final VoidCallback finished;

  CardFront({
    super.key,
    required this.creditCard,
    required this.numberFocus,
    required this.dateFocus,
    required this.nameFocus,
    required this.finished,
  });

  final MaskTextInputFormatter dateFormatter = MaskTextInputFormatter(
      mask: '!#/####', filter: {'#': RegExp('[0-9]'), '!': RegExp('[0-1]')});

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
                  initialValue: creditCard.number,
                  focusNode: numberFocus,
                  title: 'Número',
                  hint: '0000 0000 0000 0000',
                  textInputType: TextInputType.number,
                  bold: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CartaoBancarioInputFormatter(),
                  ],
                  validator: (value) {
                    if (value!.length != 19) return 'Inválido';

                    final creditCardType = detectCCType(value);

                    const creditCardTypes = [
                      CreditCardType.visa,
                      CreditCardType.mastercard,
                      CreditCardType.elo,
                    ];

                    if (creditCardTypes.any(
                        (ct) => ct.call().type == creditCardType.single.type)) {
                      return null;
                    }
                    return 'Tipo de cartão não aceito';
                  },
                  onSubmitted: (_) {
                    dateFocus.requestFocus();
                  },
                  onSaved: (number) => creditCard.setNumber(number!),
                ),
                CardTextField(
                  initialValue: creditCard.experationDate,
                  focusNode: dateFocus,
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
                  onSubmitted: (_) {
                    nameFocus.requestFocus();
                  },
                  onSaved: (date) => creditCard.setExpirationDate(date!),
                ),
                CardTextField(
                  initialValue: creditCard.holder,
                  focusNode: nameFocus,
                  title: 'Titular',
                  hint: 'João M da Silva',
                  textInputType: TextInputType.text,
                  bold: true,
                  inputFormatters: [],
                  validator: (value) {
                    if (value!.trim().isEmpty) return 'Inválido';
                    return null;
                  },
                  onSubmitted: (_) {
                    finished();
                  },
                  onSaved: (holder) => creditCard.setHolder(holder!),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
