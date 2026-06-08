import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/router/app_router.dart';
import '../../widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _moveLogo = false;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
    
    // Trigger logo movement after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _moveLogo = true;
        });
      }
    });
  }

  Future<void> _checkOnboarding() async {
    // Wait for the animation sequence: 1.5s center, 0.5s move, 2.5s show images
    await Future.delayed(const Duration(milliseconds: 4500));
    
    if (!mounted) return;
    
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
    
    hasShownSplash = true;
    
    if (!isLoggedIn) {
      context.go('/login');
    } else if (!seenOnboarding) {
      context.go('/onboarding');
    } else {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary, // Dark green/grey
      body: SafeArea(
        child: Stack(
          children: [
            // Background ingredient images that fade in after the logo moves
            if (_moveLogo)
              Positioned.fill(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 160.0, left: 16, right: 16), // Increased top padding to prevent overlap
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pure Ingredients.\nReal Wellness.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Theme.of(context).colorScheme.surface,
                            fontWeight: FontWeight.bold,
                          ),
                        ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3),
                        const SizedBox(height: 32),
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              _buildIngredientImage('assets/images/raw_millets.png', 200),
                              _buildIngredientImage('assets/images/fresh_honey.png', 400),
                              _buildIngredientImage('assets/images/almonds_dates.png', 600),
                              _buildIngredientImage('assets/images/black_rice.png', 800),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // The Animated Logo
            AnimatedAlign(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOutCubic,
              alignment: _moveLogo ? Alignment.topLeft : Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 24.0, left: 24.0), // Kept at top-left
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeInOutCubic,
                  scale: _moveLogo ? 0.6 : 1.0, // Scale it down a bit more to be safe
                  child: AppLogo(
                    size: 48,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 800.ms).shimmer(delay: 800.ms, duration: 1200.ms, color: Theme.of(context).colorScheme.secondary),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientImage(String assetPath, int delayMs) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        image: DecorationImage(
          image: AssetImage(assetPath),
          fit: BoxFit.cover,
        ),
      ),
    ).animate().fadeIn(delay: delayMs.ms, duration: 500.ms).scale(delay: delayMs.ms, curve: Curves.easeOutBack);
  }
}
