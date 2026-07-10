import 'package:flutter/material.dart';


import '../../core/theme/app_spacing.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('About Nevark'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero
            Container(
              padding: AppSpacing.edgeInsetsLg,
              color: Theme.of(context).colorScheme.primary,
              child: Text(
                'Our Story',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Theme.of(context).colorScheme.surface),
                textAlign: TextAlign.center,
              ),
            ),
            
            // Story Text
            Padding(
              padding: AppSpacing.edgeInsetsLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('From Erode to the World', style: Theme.of(context).textTheme.headlineMedium),
                  AppSpacing.gapVmd,
                  const Text(
                    'Nevark was born in the heart of Tamil Nadu, surrounded by the rich agricultural heritage of Erode and Gobichettipalayam. We started with a simple vision: to bring back the nutritional wisdom of our ancestors into modern lifestyles.',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
            
            // Values Grid
            Container(
              color: Theme.of(context).colorScheme.surface,
              padding: AppSpacing.edgeInsetsLg,
              child: Column(
                children: [
                  Text('Our Values', style: Theme.of(context).textTheme.headlineMedium),
                  AppSpacing.gapVlg,
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _buildValueCard(context, 'Health First', Icons.favorite_border),
                      _buildValueCard(context, 'Clean & Natural', Icons.eco_outlined),
                      _buildValueCard(context, 'Community', Icons.people_outline),
                      _buildValueCard(context, 'Quality', Icons.emoji_events_outlined),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueCard(BuildContext context, String title, IconData icon) {
    return Container(
      padding: AppSpacing.edgeInsetsMd,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 32),
          AppSpacing.gapVmd,
          Text(title, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

