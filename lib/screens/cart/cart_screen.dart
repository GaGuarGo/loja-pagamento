import 'package:flutter/material.dart';
import 'package:loja_virtual/common/empty_card.dart';
import 'package:loja_virtual/common/login_card.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:provider/provider.dart';

import '../../common/price_card.dart';
import 'components/cart_tile.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrinho"),
        centerTitle: true,
      ),
      body: Consumer<CartManager>(
        builder: (_, cartManager, __) {
          if (cartManager.user == null) {
            return LoginCard();
          }

          if(cartManager.items.isEmpty){
            return EmptyCard(title: 'Nenhum Produto no Carrinho', iconData: Icons.remove_shopping_cart,);
          }

          return ListView(
            children: [
              Column(
                children: cartManager.items
                    .map((cp) => CartTile(cartProduct: cp))
                    .toList(),
              ),
              PriceCard(
                buttonText: "Continuar Para Entrega",
                onPressed: cartManager.isCartValid
                    ? () {
                        Navigator.of(context).pushNamed('/address');
                      }
                    : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
