import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_spacing.dart';
import 'glass_card.dart';
import '../../providers/products_provider.dart';
import '../../providers/cart_provider.dart';

class WellnessQuiz extends ConsumerStatefulWidget {
  const WellnessQuiz({super.key});

  @override
  ConsumerState<WellnessQuiz> createState() => _WellnessQuizState();
}

class _WellnessQuizState extends ConsumerState<WellnessQuiz> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  String? _selectedGoal;

  void _nextStep() {
    if (_currentStep < 2) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() {
        _currentStep++;
      });
    }
  }

  void _resetQuiz() {
    setState(() {
      _currentStep = 0;
      _selectedGoal = null;
    });
    _pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: AppSpacing.edgeInsetsLg,
      child: SizedBox(
        height: 200,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildStep1(),
            _buildStep2(),
            _buildResult(ref),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("What is your primary wellness goal?", style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
        AppSpacing.gapVmd,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            _quizButton("Weight Management", () {
              _selectedGoal = 'weight-management';
              _nextStep();
            }),
            _quizButton("More Energy", () {
              _selectedGoal = 'daily-energy';
              _nextStep();
            }),
            _quizButton("Family Health", () {
              _selectedGoal = 'family-health';
              _nextStep();
            }),
          ],
        ),
      ],
    ).animate().fadeIn();
  }

  Widget _buildStep2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Any specific dietary focus?", style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
        AppSpacing.gapVmd,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            _quizButton("Diabetic Care", () {
              _nextStep();
            }),
            _quizButton("Kids Friendly", () {
              _nextStep();
            }),
            _quizButton("General Wellness", () {
              _nextStep();
            }),
          ],
        ),
      ],
    ).animate().fadeIn();
  }

  Widget _buildResult(WidgetRef ref) {
    final products = ref.watch(productsProvider);
    
    if (products.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("No products available to recommend right now.", textAlign: TextAlign.center),
          AppSpacing.gapVmd,
          TextButton(
            onPressed: _resetQuiz,
            child: const Text("Retake Quiz"),
          )
        ],
      ).animate().fadeIn().scale();
    }

    final match = products.firstWhere(
      (p) => p.category == _selectedGoal,
      orElse: () => products.first,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Your Perfect Match!", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary)),
        AppSpacing.gapVsm,
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.star, color: Theme.of(context).colorScheme.primary, size: 32),
          title: Text(match.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(match.benefits.isNotEmpty ? match.benefits.first : '', maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
               ref.read(cartNotifierProvider.notifier).addToCart(match);
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${match.name} added to cart')));
            },
          )
        ),
        TextButton(
          onPressed: _resetQuiz,
          child: const Text("Retake Quiz"),
        )
      ],
    ).animate().fadeIn().scale();
  }

  Widget _quizButton(String text, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(text),
    );
  }
}
