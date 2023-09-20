import 'package:flutter/material.dart';
import 'package:loja_virtual/models/section.dart';

class SectionHeader extends StatelessWidget {
  final Section section;
  const SectionHeader({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return Text(
      section.name!,
      style: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
    );
  }
}
