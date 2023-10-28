import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_icon_button.dart';
import 'package:loja_virtual/models/item_size.dart';

class EditItemSize extends StatelessWidget {
  final VoidCallback onRemove;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;
  final ItemSize size;
  const EditItemSize(
      {super.key,
      required this.size,
      required this.onRemove,
      required this.onMoveUp,
      required this.onMoveDown});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 30,
          child: TextFormField(
            onChanged: (name) => size.name = name,
            initialValue: size.name,
            decoration: const InputDecoration(
              labelText: 'Título',
              isDense: true,
            ),
            validator: (text) {
              if (text!.isEmpty) {
                return "Inválido";
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          flex: 30,
          child: TextFormField(
            onChanged: (stock) => size.stock = int.tryParse(stock),
            initialValue: size.stock?.toString(),
            decoration: const InputDecoration(
              labelText: 'Estoque',
              isDense: true,
            ),
            keyboardType: TextInputType.number,
            validator: (stock) {
              if (int.tryParse(stock!) == null) {
                return "Inválido";
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          flex: 40,
          child: TextFormField(
            onChanged: (price) => size.price = num.tryParse(price),
            initialValue: size.price?.toStringAsFixed(2),
            decoration: const InputDecoration(
              labelText: 'Preço',
              isDense: true,
              prefixText: 'R\$',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (price) {
              if (num.tryParse(price!) == null) {
                return "Inválido";
              }
              return null;
            },
          ),
        ),
        CustomIconButton(
            iconData: Icons.remove, color: Colors.red, onTap: onRemove),
        CustomIconButton(
            iconData: Icons.arrow_drop_up,
            color: Colors.black,
            onTap: onMoveUp),
        CustomIconButton(
            iconData: Icons.arrow_drop_down,
            color: Colors.black,
            onTap: onMoveDown),
      ],
    );
  }
}
