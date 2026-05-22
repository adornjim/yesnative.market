import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      appBar: AppBar(
        title: const Text('My Account'),
        backgroundColor: AppColors.warmBeige,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.edgeInsetsMd,
        child: Column(
          children: [
            // User Header (Not Logged In State)
            Container(
              padding: AppSpacing.edgeInsetsLg,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.mediumBeige,
                    child: Icon(Icons.person_outline, size: 40, color: AppColors.primaryGreen),
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
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  _buildMenuItem(context, Icons.shopping_bag_outlined, 'My Orders', () => _showLoginToast(context)),
                  const Divider(height: 1),
                  _buildMenuItem(context, Icons.favorite_border, 'Wishlist', () => _showLoginToast(context)),
                  const Divider(height: 1),
                  _buildMenuItem(context, Icons.location_on_outlined, 'Saved Addresses', () => _showLoginToast(context)),
                ],
              ),
            ),
            
            AppSpacing.gapVlg,
            
            // Company Info
            Material(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  _buildMenuItem(context, Icons.info_outline, 'About Us', () => context.push('/about')),
                  const Divider(height: 1),
                  _buildMenuItem(context, Icons.mail_outline, 'Contact Us', () => context.push('/contact')),
                  const Divider(height: 1),
                  _buildMenuItem(context, Icons.description_outlined, 'Terms & Conditions', () {}),
                  const Divider(height: 1),
                  _buildMenuItem(context, Icons.verified_user_outlined, 'Privacy Policy', () {}),
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
      leading: Icon(icon, color: AppColors.primaryGreen),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: onTap,
    );
  }

  void _showLoginToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please login to access this feature.'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }
}
