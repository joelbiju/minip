import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton(
      {super.key, required this.onPressed, required this.icon});
  final VoidCallback onPressed;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Color.fromRGBO(29, 193, 146, 1),
      child: Icon(
        icon,
        size: 35,
      ),
    );
  }
}
