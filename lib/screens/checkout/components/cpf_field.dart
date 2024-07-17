import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class CpfField extends StatelessWidget {
  const CpfField({super.key});

  @override
  Widget build(BuildContext context) {
    final userManager = context.watch<UserManager>();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CPF',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            TextFormField(
              initialValue: userManager.user!.cpf,
              decoration: InputDecoration(
                hintText: '000.000.000-00',
                isDense: true,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CpfInputFormatter()
              ],
              validator: (cpf) {
                if (cpf!.isEmpty)
                  return 'Campo Obrigatório';
                else if (!CPFValidator.isValid(cpf)) return 'CPF Inválido';
                return null;
              },
              onSaved: (cpf) => userManager.user!.setCpf(cpf!),
            ),
          ],
        ),
      ),
    );
  }
}
