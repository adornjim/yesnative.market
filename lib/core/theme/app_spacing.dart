import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  // Padding & Margins
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 64.0;

  // Edge Insets
  static const EdgeInsets edgeInsetsSm = EdgeInsets.all(sm);
  static const EdgeInsets edgeInsetsMd = EdgeInsets.all(md);
  static const EdgeInsets edgeInsetsLg = EdgeInsets.all(lg);
  
  static const EdgeInsets edgeInsetsHmd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets edgeInsetsHlg = EdgeInsets.symmetric(horizontal: lg);
  
  static const EdgeInsets edgeInsetsVmd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets edgeInsetsVxl = EdgeInsets.symmetric(vertical: xl);

  // SizedBoxes
  static const SizedBox gapHsm = SizedBox(width: sm);
  static const SizedBox gapHmd = SizedBox(width: md);
  static const SizedBox gapHlg = SizedBox(width: lg);
  
  static const SizedBox gapVsm = SizedBox(height: sm);
  static const SizedBox gapVmd = SizedBox(height: md);
  static const SizedBox gapVlg = SizedBox(height: lg);
  static const SizedBox gapVxl = SizedBox(height: xl);
  static const SizedBox gapVxxl = SizedBox(height: xxl);
}
