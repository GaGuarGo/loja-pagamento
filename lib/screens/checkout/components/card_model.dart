import 'package:flutter/material.dart';

class CardModal extends StatelessWidget {
  final Widget? content;
  final bool? padding;
  const CardModal({super.key, required this.content, this.padding = true});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 16.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: padding! ? const EdgeInsets.all(24) : EdgeInsets.zero,
        height: 200,
        color: const Color(0xFF1B4B52),
        child: content,
      ),
    );
  }
}
