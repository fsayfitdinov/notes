import 'package:flutter/material.dart';

class DefaultTextButton extends StatelessWidget {
  final String title;
  final Function press;
  final Color color;
  final Color? textColor;
  const DefaultTextButton({
    Key? key,
    required this.title,
    required this.press,
    required this.color,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      onPressed: () => press(),
      child: Text(
        title,
        style: TextStyle(color: textColor ?? Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}
