import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CepInputField extends StatelessWidget {
  const CepInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          decoration: const InputDecoration(
              isDense: true, labelText: 'CEP', hintText: '12.345-678'),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text(
            "Buscar CEP",
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              disabledBackgroundColor:
                  Theme.of(context).primaryColor.withAlpha(100),
              textStyle: const TextStyle(color: Colors.white),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
        ),
      ],
    );
  }
}
