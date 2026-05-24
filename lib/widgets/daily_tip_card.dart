import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_spacing.dart';
import 'glass_card.dart';

class DailyTipCard extends StatelessWidget {
  const DailyTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = [
      "Start your morning with warm water and a pinch of turmeric.",
      "Take 5 deep breaths before your first meal to aid digestion.",
      "A 10-minute walk after meals helps balance blood sugar.",
      "Stay hydrated: drink a glass of water right when you wake up.",
      "Incorporate more colors into your meals with fresh vegetables."
    ];
    
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final dailyTip = tips[dayOfYear % tips.length];

    return GlassCard(
      padding: AppSpacing.edgeInsetsLg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, color: Theme.of(context).colorScheme.primary, size: 28),
          AppSpacing.gapHmd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Daily Wellness Tip",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                AppSpacing.gapVsm,
                Text(
                  dailyTip,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1);
  }
}
