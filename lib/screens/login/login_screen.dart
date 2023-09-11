// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:loja_virtual/helpers/validators.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Entrar"),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("/signup");
              },
              child: const Text(
                ' CRIAR CONTA ',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ))
        ],
      ),
      body: Center(
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
              key: _formKey,
              child: Consumer<UserManager>(
                builder: (_, userManager, __) {
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    shrinkWrap: true,
                    children: [
                      TextFormField(
                        enabled: !userManager.loading,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        decoration: const InputDecoration(hintText: "E-mail"),
                        validator: (email) {
                          if (!emailValid(email!)) {
                            return "E-mail Inválido";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: passwordController,
                        enabled: !userManager.loading,
                        autocorrect: false,
                        decoration: const InputDecoration(hintText: "Senha"),
                        obscureText: true,
                        validator: (password) {
                          if (password!.isEmpty || password.length < 6) {
                            return "Senha Inválida!";
                          }
                          return null;
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text("Esqueci minha Senha"),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: userManager.loading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    userManager.signIn(
                                        user: UserModel(
                                            email: emailController.text,
                                            password: passwordController.text),
                                        onFail: (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content:
                                                Text("Falha ao Entrar: $e"),
                                            backgroundColor: Colors.red,
                                          ));
                                        },
                                        onSuccess: () {
                                          //TODO: FECHA TELA DE LOGIN
                                        });
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              disabledBackgroundColor:
                                  Theme.of(context).primaryColor.withAlpha(100),
                              textStyle: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                              backgroundColor: Theme.of(context).primaryColor),
                          child: userManager.loading
                              ? const CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : const Text("Entrar"),
                        ),
                      ),
                    ],
                  );
                },
              )),
        ),
      ),
    );
  }
}
