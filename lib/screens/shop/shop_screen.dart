import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../providers/products_provider.dart';
import '../../widgets/product_card.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  String _selectedCategory = 'all';

  final List<Map<String, String>> _categories = [
    {'id': 'all', 'label': 'All Products'},
    {'id': 'weight-management', 'label': 'Weight Management'},
    {'id': 'family-health', 'label': 'Family Health'},
    {'id': 'natural-nourishment', 'label': 'Natural Nourishment'},
    {'id': 'kids-nutrition', 'label': 'Kids Nutrition'},
    {'id': 'daily-energy', 'label': 'Daily Energy'},
    {'id': 'womens-wellness', 'label': 'Women\'s Wellness'},
  ];

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productsByCategoryProvider(_selectedCategory));

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      appBar: AppBar(
        title: const Text('Our Products'),
        backgroundColor: AppColors.warmBeige,
      ),
      body: Column(
        children: [
          // Category Filter Bar
          Container(
            height: 60,
            padding: AppSpacing.edgeInsetsHmd,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category['id'];
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0, top: 12, bottom: 12),
                  child: ChoiceChip(
                    label: Text(category['label']!),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedCategory = category['id']!);
                      }
                    },
                    selectedColor: AppColors.primaryGreen,
                    backgroundColor: AppColors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.primaryGreen,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? AppColors.primaryGreen : Colors.grey.shade300,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Results Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Text(
                  'Showing ${products.length} products',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          // Product Grid
          Expanded(
            child: products.isEmpty
                ? const Center(
                    child: Text('No products found for this category.'),
                  )
                : GridView.builder(
                    padding: AppSpacing.edgeInsetsMd,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.58, // Taller cards for mobile
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: products[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}