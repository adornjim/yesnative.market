import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/theme/app_spacing.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_logo.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
<<<<<<< HEAD
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.edgeInsetsLg,
        child: Column(
          children: [
            AppSpacing.gapVxl,
            Text(
              _isLogin ? 'Welcome Back' : 'Create Account',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            AppSpacing.gapVsm,
            Text(
              _isLogin ? 'Login to continue your wellness journey' : 'Join us for a healthier lifestyle',
              style: TextStyle(color: Colors.grey[600]),
            ),
            AppSpacing.gapVxl,
            
            // Form Card
            Container(
              padding: AppSpacing.edgeInsetsLg,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  if (!_isLogin) ...[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    AppSpacing.gapVmd,
                  ],
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: const Icon(Icons.mail_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  AppSpacing.gapVmd,
                  TextFormField(
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  
                  if (_isLogin)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('Forgot Password?'),
                      ),
                    ),
                    
                  AppSpacing.gapVlg,
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Demo logic
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: AppSpacing.edgeInsetsVmd,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(_isLogin ? 'Login' : 'Sign Up', style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                  
                  AppSpacing.gapVlg,
                  
                  // Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_isLogin ? "Don't have an account?" : "Already have an account?"),
                      TextButton(
                        onPressed: () => setState(() => _isLogin = !_isLogin),
                        child: Text(_isLogin ? 'Sign Up' : 'Login'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
=======
      backgroundColor: Theme.of(context).colorScheme.primary, // Dark green background
      body: Column(
        children: [
          // Top Half (Dark Green)
          Expanded(
            flex: 4,
            child: SafeArea(
              bottom: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppLogo(size: 64, color: Colors.white).animate().fadeIn().scale(),
                  AppSpacing.gapVmd,
                  AppSpacing.gapVsm,
                  const Text(
                    'Functional Superfoods',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      letterSpacing: 1.5,
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideY(),
                ],
              ),
            ),
          ),
          
          // Bottom Half (Cream rounded container)
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF9F6F0), // Light cream color matching the image
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.1),
                  AppSpacing.gapVsm,
                  Text(
                    'Sign in to manage your orders and profile',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 16,
                    ),
                  ).animate().fadeIn(delay: 700.ms).slideX(begin: -0.1),
                  
                  AppSpacing.gapVxl,
                  AppSpacing.gapVmd,
                  
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
                      icon: _buildGoogleIcon(),
                      label: const Text(
                        'Continue with Google',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: AppSpacing.edgeInsetsVmd,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.2),
                ],
              ),
            ),
          ),
        ],
>>>>>>> a1d2ec749c22cce69ad9367bfcf45e0486be5ccf
      ),
    );
  }

  Widget _buildGoogleIcon() {
    const String googleLogoSvg = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M22.56 12.25C22.56 11.47 22.49 10.72 22.36 10H12V14.26H17.92C17.67 15.63 16.89 16.81 15.71 17.58V20.34H19.27C21.36 18.42 22.56 15.6 22.56 12.25Z" fill="#4285F4"/>
<path d="M12 23C14.97 23 17.46 22.02 19.27 20.34L15.71 17.58C14.73 18.24 13.48 18.64 12 18.64C9.13 18.64 6.7 16.7 5.82 14.1H2.15V16.94C3.96 20.54 7.69 23 12 23Z" fill="#34A853"/>
<path d="M5.82 14.1C5.59 13.43 5.46 12.72 5.46 12C5.46 11.28 5.59 10.57 5.82 9.9V7.06H2.15C1.41 8.54 1 10.22 1 12C1 13.78 1.41 15.46 2.15 16.94L5.82 14.1Z" fill="#FBBC05"/>
<path d="M12 5.38C13.62 5.38 15.06 5.93 16.2 7.02L19.34 3.88C17.45 2.12 14.97 1 12 1C7.69 1 3.96 3.46 2.15 7.06L5.82 9.9C6.7 7.3 9.13 5.38 12 5.38Z" fill="#EA4335"/>
</svg>
''';
    return SvgPicture.string(googleLogoSvg, width: 24, height: 24);
  }
}
