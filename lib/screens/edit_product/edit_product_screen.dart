// ignore_for_file: avoid_print, unnecessary_null_comparison, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:provider/provider.dart';
import 'components/images_form.dart';
import 'components/sizes_form.dart';

class EditProductScreen extends StatelessWidget {
  final Product product;
  final bool editing;

  EditProductScreen(Product? p)
      : product = p?.clone() ?? Product(),
        editing = p != null;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(editing ? "Editar Produto" : "Criar Produto"),
          centerTitle: true,
        ),
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              ImagesForm(product: product),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        initialValue: product.name,
                        decoration: const InputDecoration(
                          hintText: 'Título',
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                        validator: (name) {
                          if (name!.length < 6) {
                            return 'Título muito curto!';
                          }
                          return null;
                        },
                        onSaved: (name) => product.name = name,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'A partir de',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Text(
                        'R\$ ...',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text(
                          'Descrição',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      TextFormField(
                        initialValue: product.description,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          hintText: 'Descrição',
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                        validator: (desc) {
                          if (desc!.length < 10) {
                            return 'Descrição Muito Curta!';
                          }
                          return null;
                        },
                        onSaved: (desc) => product.description = desc,
                      ),
                      SizesForm(product),
                      Consumer<Product>(
                        builder: (_, product, __) {
                          return Container(
                            height: 40,
                            margin: const EdgeInsets.only(top: 8),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                disabledBackgroundColor:
                                    primaryColor.withAlpha(100),
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: !product.loading
                                  ? () async {
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState!.save();

                                        await product.save();

                                        context
                                            .read<ProductManager>()
                                            .update(product);

                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pop();
                                      } else {
                                        print("Inválido");
                                      }
                                    }
                                  : null,
                              child: !product.loading
                                  ? const Text(
                                      "Salvar",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : const CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white),
                                    ),
                            ),
                          );
                        },
                      ),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
