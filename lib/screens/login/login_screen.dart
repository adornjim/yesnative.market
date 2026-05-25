import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_spacing.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_logo.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.edgeInsetsLg,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              AppLogo(size: 64, color: Theme.of(context).colorScheme.primary).animate().fadeIn().scale(),
              AppSpacing.gapVxl,
              Text(
                'Welcome to Yes Native',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 200.ms).slideY(),
              AppSpacing.gapVsm,
              Text(
                'Discover functional superfoods crafted from ancient wisdom.',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 400.ms).slideY(),
              const Spacer(),
              
              // Google Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await ref.read(authProvider.notifier).signInWithGoogle();
                    final prefs = await SharedPreferences.getInstance();
                    final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
                    if (!context.mounted) return;
                    
                    if (!seenOnboarding) {
                      context.go('/onboarding');
                    } else {
                      context.go('/');
                    }
                  },
                  icon: const Icon(Icons.g_mobiledata, size: 32),
                  label: const Text('Continue with Google', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    padding: AppSpacing.edgeInsetsVmd,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade200)
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.5),
              AppSpacing.gapVxl,
            ],
          ),
        ),
      ),
    );
  }
}
