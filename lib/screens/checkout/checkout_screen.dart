import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../providers/cart_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int _currentStep = 0;
  bool _isSuccess = false;

  @override
  Widget build(BuildContext context) {
    if (_isSuccess) return _buildSuccessScreen();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep == 2) {
            setState(() => _isSuccess = true);
            ref.read(cartNotifierProvider.notifier).clearCart();
          } else {
            setState(() => _currentStep += 1);
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          } else {
            context.pop();
          }
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: Text(_currentStep == 2 ? 'Place Order' : 'Continue'),
                  ),
                ),
                if (_currentStep > 0) ...[
                  AppSpacing.gapHmd,
                  Expanded(
                    child: OutlinedButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back'),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Shipping'),
            content: _buildShippingForm(),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Payment'),
            content: _buildPaymentMethod(),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Review'),
            content: _buildReview(ref),
            isActive: _currentStep >= 2,
          ),
        ],
      ),
    );
  }

  Widget _buildShippingForm() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
        ),
        AppSpacing.gapVmd,
        TextFormField(
          decoration: const InputDecoration(labelText: 'Address', border: OutlineInputBorder()),
          maxLines: 3,
        ),
        AppSpacing.gapVmd,
        TextFormField(
          decoration: const InputDecoration(labelText: 'City', border: OutlineInputBorder()),
        ),
        AppSpacing.gapVmd,
        TextFormField(
          decoration: const InputDecoration(labelText: 'Pincode', border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
        ),
      ],
    ).animate().fadeIn().slideX(begin: 0.1);
  }

  Widget _buildPaymentMethod() {
    return Column(
      children: [
        RadioListTile(
          value: 'upi',
          groupValue: 'upi',
          onChanged: (val) {},
          title: const Text('UPI (Google Pay, PhonePe)'),
          secondary: const Icon(Icons.qr_code),
        ),
        RadioListTile(
          value: 'card',
          groupValue: 'upi',
          onChanged: (val) {},
          title: const Text('Credit/Debit Card'),
          secondary: const Icon(Icons.credit_card),
        ),
        RadioListTile(
          value: 'cod',
          groupValue: 'upi',
          onChanged: (val) {},
          title: const Text('Cash on Delivery'),
          secondary: const Icon(Icons.money),
        ),
      ],
    ).animate().fadeIn().slideX(begin: 0.1);
  }

  Widget _buildReview(WidgetRef ref) {
    final total = ref.watch(cartTotalProvider);
    return Container(
      padding: AppSpacing.edgeInsetsLg,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Order Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Amount to Pay:'),
              Text('₹$total', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.1);
  }

  Widget _buildSuccessScreen() {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Icon(Icons.check, size: 64, color: Theme.of(context).colorScheme.primary),
            ).animate().scale(delay: 200.ms, duration: 400.ms, curve: Curves.easeOutBack),
            AppSpacing.gapVxl,
            Text(
              'Order Placed Successfully!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.surface),
            ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.5),
            AppSpacing.gapVmd,
            Text(
              'Your wellness journey continues.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.surface.withOpacity(0.8)),
            ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.5),
            AppSpacing.gapVxl,
            ElevatedButton(
              onPressed: () => context.go('/'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surface,
                foregroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              ),
              child: const Text('Continue Shopping'),
            ).animate().fadeIn(delay: 1000.ms),
          ],
        ),
      ),
    );
  }
}
