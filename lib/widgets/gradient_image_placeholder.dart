import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class GradientImagePlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget? child;
  final BorderRadius? borderRadius;

  const GradientImagePlaceholder({
    super.key,
    this.width,
    this.height,
    this.child,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.warmBeige,
            AppColors.mediumBeige,
            AppColors.lightTan,
          ],
        ),
      ),
      child: child,
    );
  }
}
