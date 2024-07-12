import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/checkout/components/card_model.dart';
import 'package:loja_virtual/screens/checkout/components/card_text_field.dart';

class CardFront extends StatelessWidget {
  const CardFront({super.key});

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
                ),
                CardTextField(
                  title: 'Validade',
                  hint: '12/24',
                  textInputType: TextInputType.number,
                ),
                CardTextField(
                  title: 'Titular',
                  hint: 'João M da Silva',
                  textInputType: TextInputType.text,
                  bold: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
