import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Account'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.edgeInsetsMd,
        child: Column(
          children: [
            // User Header
            Container(
              padding: AppSpacing.edgeInsetsLg,
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
              child: authState.isLoggedIn
                  ? Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: Text(
                            authState.userName?[0].toUpperCase() ?? 'U',
                            style: TextStyle(fontSize: 32, color: Theme.of(context).colorScheme.surface),
                          ),
                        ),
                        AppSpacing.gapVmd,
                        Text(authState.userName ?? 'User', style: Theme.of(context).textTheme.titleLarge),
                        AppSpacing.gapVsm,
                        Text(authState.userEmail ?? '', style: TextStyle(color: Colors.grey[600])),
                        AppSpacing.gapVlg,
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              ref.read(authProvider.notifier).signOut();
                              context.go('/login');
                            },
                            child: const Text('Sign Out'),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: Icon(Icons.person_outline, size: 40, color: Theme.of(context).colorScheme.primary),
                        ),
                        AppSpacing.gapVmd,
                        Text('Welcome to Yes Native', style: Theme.of(context).textTheme.titleLarge),
                        AppSpacing.gapVsm,
                        const Text('Login to access your orders and saved items.', textAlign: TextAlign.center),
                        AppSpacing.gapVlg,
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => context.push('/login'),
                            child: const Text('Login / Sign Up'),
                          ),
                        ),
                      ],
                    ),
            ),
            
            AppSpacing.gapVlg,
            
            // Menu Items
            Material(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  _buildMenuItem(context, Icons.shopping_bag_outlined, 'My Orders', () => context.push('/orders')),
                  const Divider(height: 1),
                  _buildMenuItem(context, Icons.favorite_border, 'Wishlist', () => context.push('/wishlist')),
                  const Divider(height: 1),
                  _buildMenuItem(context, Icons.location_on_outlined, 'Saved Addresses', () => context.push('/addresses')),
                ],
              ),
            ),
            
            AppSpacing.gapVlg,

            // Settings
            Material(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: SwitchListTile(
                title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w500)),
                secondary: Icon(Icons.dark_mode_outlined, color: Theme.of(context).colorScheme.primary),
                value: ref.watch(themeProvider) == ThemeMode.dark,
                activeThumbColor: Theme.of(context).colorScheme.secondary,
                onChanged: (val) {
                  ref.read(themeProvider.notifier).toggleTheme();
                },
              ),
            ),
            
            AppSpacing.gapVlg,
            
            // Company Info
            Material(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  _buildMenuItem(context, Icons.info_outline, 'About Us', () => context.push('/about')),
                  const Divider(height: 1),
                  _buildMenuItem(context, Icons.mail_outline, 'Contact Us', () => context.push('/contact')),
                ],
              ),
            ),
            
            AppSpacing.gapVxl,
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: onTap,
    );
  }

  void _showLoginToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Please login to access this feature.'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
