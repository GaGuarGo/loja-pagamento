import 'package:flutter/material.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:loja_virtual/screens/login/login_screen.dart';
import 'package:provider/provider.dart';

// ignore: use_key_in_widget_constructors
class BaseScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (BuildContext context) => PageManager(_pageController),
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          LoginScreen(),
          Container(
            color: Colors.red,
          ),
          Container(
            color: Colors.yellow,
          ),
          Container(
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
