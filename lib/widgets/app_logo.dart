import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final Color? color;

  const AppLogo({
    super.key,
    this.size = 32.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final logoColor = color ?? Theme.of(context).colorScheme.primary;

    return Image.asset(
      'assets/images/logo.png',
      height: size * 1.8,
      fit: BoxFit.contain,
      color: logoColor,
    );
  }
}
