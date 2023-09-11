import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Criar Conta"),
        centerTitle: true,
      ),
      body: Center(
          child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(hintText: 'Nome Completo'),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'E-mail'),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Senha'),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              obscureText: false,
              decoration: const InputDecoration(hintText: 'Repita a Senha'),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor:
                        Theme.of(context).primaryColor.withAlpha(100),
                    textStyle:
                        const TextStyle(color: Colors.white, fontSize: 18),
                    backgroundColor: Theme.of(context).primaryColor),
                child: const Text("Criar Conta"),
              ),
            )
          ],
        ),
      )),
    );
  }
}
