import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_spacing.dart';
import '../../widgets/daily_tip_card.dart';
import '../../widgets/wellness_streak.dart';
import '../../widgets/wellness_quiz.dart';
import '../shop/shop_screen.dart';

class WellnessScreen extends ConsumerStatefulWidget {
  const WellnessScreen({super.key});

  @override
  ConsumerState<WellnessScreen> createState() => _WellnessScreenState();
}

class _WellnessScreenState extends ConsumerState<WellnessScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Wellness Hub'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.edgeInsetsLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const WellnessStreak(),
            AppSpacing.gapVlg,
            const DailyTipCard(),
            AppSpacing.gapVlg,
            const WellnessQuiz(),
            AppSpacing.gapVlg,
            
            Text(
              "Explore by Category",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ).animate().fadeIn(),
            AppSpacing.gapVmd,
            
            // Categories Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _buildWeightManagementCard(),
                _buildCategoryCard('daily-energy', 'Daily Energy', '1 Product', Icons.bolt),
                _buildCategoryCard('kids-nutrition', 'Kids Nutrition', '1 Product', Icons.child_care),
                _buildCategoryCard('womens-wellness', 'Women\'s Wellness', '1 Product', Icons.auto_awesome),
                _buildCategoryCard('family-health', 'Family Health', '2 Products', Icons.people_outline),
                _buildCategoryCard('natural-nourishment', 'Natural Nourishment', '1 Product', Icons.eco_outlined),
              ],
            ).animate().fadeIn().slideY(begin: 0.1),
            
          ],
        ),
      ),
    );
  }

  Widget _buildWeightManagementCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ShopScreen(selectedCategory: 'weight-management'),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.monitor_weight_outlined,
                size: 40,
                color: Color(0xFF234F2A)),
            SizedBox(height: 20),
            Text(
              "Weight Management",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String id, String title, String subtitle, IconData icon) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShopScreen(selectedCategory: id),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: AppSpacing.edgeInsetsMd,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: AppSpacing.edgeInsetsSm,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
            ),
            AppSpacing.gapVmd,
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
