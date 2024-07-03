import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData iconData;
  final Color color;
  final double? size;
  final VoidCallback? onTap;
  const CustomIconButton(
      {super.key,
      required this.iconData,
      required this.color,
      required this.onTap,
      this.size});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(
              iconData,
              size: size ?? 24,
              color: onTap != null ? color : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
