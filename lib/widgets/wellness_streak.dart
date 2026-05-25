import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_spacing.dart';
import 'glass_card.dart';

class WellnessStreak extends StatelessWidget {
  const WellnessStreak({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: AppSpacing.edgeInsetsMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Wellness Streak",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          AppSpacing.gapVsm,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final isCompleted = index < 3; // Hardcoded to 3 days for now
              final isToday = index == 3;
              return Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted
                      ? Theme.of(context).colorScheme.primary
                      : isToday
                          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
                          : Theme.of(context).colorScheme.surface,
                  border: Border.all(
                    color: isCompleted || isToday
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade300,
                  ),
                ),
                child: isCompleted
                    ? const Icon(Icons.check, size: 18, color: Colors.white)
                    : null,
              ).animate(delay: (index * 100).ms).scale(curve: Curves.easeOutBack);
            }),
          ),
          AppSpacing.gapVsm,
          Text(
            "3-day streak! Keep it up. 🌿",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.primary),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 800.ms),
        ],
      ),
    );
  }
}
