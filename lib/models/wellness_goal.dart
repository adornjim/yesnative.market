import 'package:flutter/material.dart';

class WellnessGoal {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final int productCount;
  final List<Color> gradientColors;

  const WellnessGoal({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.productCount,
    required this.gradientColors,
  });
}
