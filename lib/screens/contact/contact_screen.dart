import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Contact Us'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.edgeInsetsLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // WhatsApp CTA
            InkWell(
              onTap: () => launchUrl(Uri.parse('https://wa.me/919876543210')),
              child: Container(
                padding: AppSpacing.edgeInsetsLg,
                decoration: BoxDecoration(
                  color: AppColors.whatsappGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.whatsappGreen),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: AppSpacing.edgeInsetsSm,
                      decoration: const BoxDecoration(color: AppColors.whatsappGreen, shape: BoxShape.circle),
                      child: Icon(Icons.chat_bubble_outline, color: Theme.of(context).colorScheme.surface),
                    ),
                    AppSpacing.gapHmd,
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Chat with us on WhatsApp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('Fastest response time', style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            AppSpacing.gapVxl,
            
            Text('Send a Message', style: Theme.of(context).textTheme.headlineMedium),
            AppSpacing.gapVmd,
            
            // Form
            Container(
              padding: AppSpacing.edgeInsetsLg,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                  ),
                  AppSpacing.gapVmd,
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                  ),
                  AppSpacing.gapVmd,
                  TextFormField(
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: 'Message', border: OutlineInputBorder()),
                  ),
                  AppSpacing.gapVlg,
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Message sent successfully!')),
                        );
                      },
                      child: const Text('Send Message'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


