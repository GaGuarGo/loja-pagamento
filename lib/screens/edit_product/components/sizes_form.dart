// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:loja_virtual/models/item_size.dart';
import 'package:loja_virtual/models/product.dart';

import 'edit_item_size.dart';

class SizesForm extends StatelessWidget {
  final Product product;
  const SizesForm(this.product);

  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemSize>>(
      initialValue: product.sizes,
      builder: (state) {
        return Column(
          children: state.value!.map((size) {
            return EditItemSize(size: size);
          }).toList(),
        );
      },
    );
  }
}
