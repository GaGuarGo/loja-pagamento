// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product.dart';

import 'components/images_form.dart';

class EditProductScreen extends StatelessWidget {
  final Product product;

  EditProductScreen({super.key, required this.product});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Editar Anúncio"),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            ImagesForm(product: product),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  print("Válido");
                } else {
                  print("Inválido");
                }
              },
              child: const Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}
