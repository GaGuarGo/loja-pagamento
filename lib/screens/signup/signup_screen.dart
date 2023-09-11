import 'package:flutter/material.dart';
import 'package:loja_virtual/helpers/validators.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  final UserModel user = UserModel();

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
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: 'Nome Completo'),
                onSaved: (name) => user.name = name,
                validator: (nome) {
                  if (nome!.isEmpty) {
                    return 'Campo Obrigatório';
                  } else if (nome.trim().split(' ').length <= 1) {
                    return 'Preencha seu Nome Completo';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'E-mail'),
                onSaved: (email) => user.email = email,
                validator: (email) {
                  if (email!.isEmpty) {
                    return 'Campo Obrigatório';
                  } else if (!emailValid(email)) {
                    return 'E-mail Inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Senha'),
                onSaved: (pass) => user.password = pass,
                validator: (pass) {
                  if (pass!.isEmpty) {
                    return 'Campo Obrigatório';
                  } else if (pass.length < 6) {
                    return "Senha Muito Curta!";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Repita a Senha'),
                onSaved: (confirmedPassword) =>
                    user.confirmPassword = confirmedPassword,
                validator: (pass) {
                  if (pass!.isEmpty) {
                    return 'Campo Obrigatório';
                  } else if (pass.length < 6) {
                    return "Senha Muito Curta!";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      if (user.password != user.confirmPassword) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Senhas Diferentes!",
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.red,
                        ));

                        return;
                      }
                      context.read<UserManager>().signUp(
                            user: user,
                            onFail: (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Falha ao Cadastrar: $e"),
                                backgroundColor: Colors.red,
                              ));
                            },
                            onSuccess: () {
                              // Navigator.pop(context);
                              print("Sucesso!");
                            },
                          );
                    }
                  },
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
        ),
      )),
    );
  }
}
