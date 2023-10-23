// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_icon_button.dart';
import 'package:loja_virtual/models/item_size.dart';
import 'package:loja_virtual/models/product.dart';

import 'edit_item_size.dart';

class SizesForm extends StatelessWidget {
  final Product product;
  const SizesForm(this.product);

  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemSize>>(
      initialValue: product.sizes!,
      validator: (sizes) {
        if (sizes!.isEmpty) {
          return 'Insira um Tamanho';
        }
        return null;
      },
      builder: (state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tamanhos',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                CustomIconButton(
                    iconData: Icons.add,
                    color: Colors.black,
                    onTap: () {
                      state.value!.add(ItemSize());
                      state.didChange(state.value);
                    }),
              ],
            ),
            Column(
              children: state.value!.map((size) {
                return EditItemSize(
                  key: ObjectKey(size),
                  size: size,
                  onRemove: () {
                    state.value?.remove(size);
                    state.didChange(state.value);
                  },
                  onMoveUp: size != state.value!.first
                      ? () {
                          final index = state.value?.indexOf(size);
                          state.value!.remove(size);
                          state.value!.insert(index! - 1, size);
                          state.didChange(state.value);
                        }
                      : null,
                  onMoveDown: size != state.value!.last
                      ? () {
                          final index = state.value?.indexOf(size);
                          state.value!.remove(size);
                          state.value!.insert(index! + 1, size);
                          state.didChange(state.value);
                        }
                      : null,
                );
              }).toList(),
            ),
            if (state.hasError)
              Container(
                alignment: Alignment.centerLeft,
                // margin: const EdgeInsets.only(top: 16, left: 16),
                child: Text(
                  state.errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              )
          ],
        );
      },
    );
  }
}
