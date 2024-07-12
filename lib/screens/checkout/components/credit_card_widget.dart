import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/checkout/components/card_back.dart';
import 'package:loja_virtual/screens/checkout/components/card_front.dart';

class CreditCardWidget extends StatelessWidget {
  CreditCardWidget({super.key});

  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

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
            front: CardFront(),
            back: CardBack(),
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
