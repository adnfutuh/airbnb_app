import 'package:flutter/material.dart';

class MyIconButton extends StatelessWidget {
  final IconData icon;
  final double? radius;
  final Color? bgIconColor;
  final Color? iconColor;

  const MyIconButton({
    super.key,
    required this.icon,
    this.radius,
    this.bgIconColor = Colors.white,
    this.iconColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: bgIconColor,
      child: Center(
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );
  }
}
