import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product.dart';

import 'components/images_form.dart';

class EditProductScreen extends StatelessWidget {
  final Product product;

  const EditProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Anúncio"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ImagesForm(
            product: product,
          ),
        ],
      ),
    );
  }
}
