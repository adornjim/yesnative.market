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
    // Wait for the animation sequence: 1.5s center, 0.8s move, then transition
    await Future.delayed(const Duration(milliseconds: 2500));
    
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
}
