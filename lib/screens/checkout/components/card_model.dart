import 'package:flutter/material.dart';

class CardModal extends StatelessWidget {
  final Widget? content;
  const CardModal({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 16.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        height: 200,
        color: const Color(0xFF1B4B52),
        child: content,
      ),
    );
  }
}
