import 'package:flutter/material.dart';
import 'package:loja_virtual/common/price_card.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/checkout_manager.dart';
import 'package:loja_virtual/screens/checkout/components/cpf_field.dart';
import 'package:loja_virtual/screens/checkout/components/credit_card_widget.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {
  CheckoutScreen({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (context, cartManager, checkoutManager) =>
          checkoutManager!..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pagamento'),
          centerTitle: true,
        ),
        body: Consumer<CheckoutManager>(
          builder: (_, checkoutManager, __) {
            if (checkoutManager.laoding)
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Processando seu Pagamento...',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );

            return Form(
              key: formKey,
              child: ListView(
                children: [
                  CreditCardWidget(),
                  CpfField(),
                  PriceCard(
                    buttonText: 'Finalizar Pedido',
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        formKey.currentState?.save();
                      }

                      // checkoutManager.checkout(onStockFail: (e) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(
                      //       backgroundColor: Colors.red,
                      //       content: Text(
                      //         e.toString(),
                      //         style: TextStyle(color: Colors.white),
                      //       ),
                      //     ),
                      //   );
                      //   Navigator.of(context).popUntil(
                      //       (route) => route.settings.name == '/cart');
                      // }, onSuccess: (order) {
                      //   Navigator.of(context)
                      //       .popUntil((route) => route.settings.name == '/');
                      //   Navigator.of(context)
                      //       .pushNamed('/confirmation', arguments: order);
                      // });
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
