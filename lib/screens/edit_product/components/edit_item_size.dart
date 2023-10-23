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
            initialValue: size.name,
            decoration: const InputDecoration(
              labelText: 'Título',
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: size.stock?.toString(),
            decoration: const InputDecoration(
              labelText: 'Estoque',
              isDense: true,
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          flex: 40,
          child: TextFormField(
            initialValue: size.price?.toStringAsFixed(2),
            decoration: const InputDecoration(
                labelText: 'Preço', isDense: true, prefixText: 'R\$'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
