import 'package:flutter/material.dart';

class CustomPrefixIcon extends StatelessWidget {
  final IconData icon;
  const CustomPrefixIcon({
    Key? key,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}
