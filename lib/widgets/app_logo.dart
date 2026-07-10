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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark ? Colors.white : Theme.of(context).colorScheme.primary;
    final logoColor = color ?? defaultColor;

    return Hero(
      tag: 'app_logo',
      child: Image.asset(
        'assets/images/nevarkfoods.png',
        height: size * 1.8,
        fit: BoxFit.contain,
        color: logoColor,
      ),
    );
  }
}
