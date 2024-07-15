import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/screens/checkout/components/card_model.dart';
import 'package:loja_virtual/screens/checkout/components/card_text_field.dart';

class CardBack extends StatelessWidget {
  final FocusNode cvvFocus;

  const CardBack({super.key, required this.cvvFocus});

  @override
  Widget build(BuildContext context) {
    return CardModal(
      padding: false,
      content: Column(
        children: [
          Container(
            color: Colors.black,
            height: 40,
            margin: EdgeInsets.symmetric(vertical: 16),
          ),
          Row(
            children: [
              Expanded(
                flex: 70,
                child: Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(left: 12),
                  color: Colors.grey.shade500,
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: CardTextField(
                    focusNode: cvvFocus,
                    textAlign: TextAlign.end,
                    hint: '123',
                    textInputType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 3,
                    validator: (value) {
                      if (value!.isEmpty || value.length != 3) {
                        return 'Inválido';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 30,
                child: Container(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
