import 'package:flutter/material.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/section.dart';
import 'package:provider/provider.dart';

class AddSectionWidget extends StatelessWidget {
  const AddSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
              flex: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  homeManager.addSection(Section(type: 'List'));
                },
                child: Text(
                  'Adicionar Lista',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              )),
          SizedBox(width: 4),
          Expanded(
              flex: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  homeManager.addSection(Section(type: 'Staggered'));
                },
                child: Text(
                  'Adicionar Grade',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              )),
        ],
      ),
    );
  }
}
