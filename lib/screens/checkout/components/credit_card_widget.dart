import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/credit_card.dart';
import 'package:loja_virtual/screens/checkout/components/card_back.dart';
import 'package:loja_virtual/screens/checkout/components/card_front.dart';

class CreditCardWidget extends StatefulWidget {
  final CreditCard creditCard;
  const CreditCardWidget({super.key, required this.creditCard});

  @override
  State<CreditCardWidget> createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget> {
  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  final numberFocus = FocusNode();

  final dateFocus = FocusNode();

  final nameFocus = FocusNode();

  final cvvFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FlipCard(
            key: cardKey,
            flipOnTouch: false,
            direction: FlipDirection.HORIZONTAL,
            speed: 700,
            front: CardFront(
              creditCard: widget.creditCard,
              numberFocus: numberFocus,
              dateFocus: dateFocus,
              nameFocus: nameFocus,
              finished: () {
                cardKey.currentState?.toggleCard();
                cvvFocus.requestFocus();
              },
            ),
            back: CardBack(
              creditCard: widget.creditCard,
              cvvFocus: cvvFocus,
            ),
          ),
          TextButton(
            onPressed: () {
              cardKey.currentState?.toggleCard();
            },
            child: Text(
              'Virar Cartão',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
