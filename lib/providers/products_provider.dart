import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

final List<Product> _hardcodedProducts = [
  const Product(
    id: 1,
    name: 'SlimSure Lite',
    price: 499,
    category: 'weight-management',
    rating: 4.8,
    reviews: 124,
    benefits: ['Low Glycemic Index', 'High in Dietary Fiber', 'Sustained Energy Release'],
    imageUrl: 'assets/images/prod_1.jpg',
  ),
  const Product(
    id: 2,
    name: 'Black Rice Choco Malt',
    price: 599,
    category: 'family-health',
    rating: 4.9,
    reviews: 198,
    benefits: ['Rich in Antioxidants', 'Kid-Friendly Taste', 'Immunity Boosting'],
    imageUrl: 'assets/images/prod_4.jpg',
  ),
  const Product(
    id: 3,
    name: 'Palm Cube Badam Mix',
    price: 699,
    category: 'natural-nourishment',
    rating: 4.7,
    reviews: 87,
    benefits: ['Natural Sweetener', 'Rich in Vitamin E', 'Brain Health Support'],
    imageUrl: 'assets/images/prod_6.jpg',
  ),
  const Product(
    id: 4,
    name: 'Sprouted Ragi Choco Malt',
    price: 549,
    category: 'kids-nutrition',
    rating: 4.8,
    reviews: 156,
    benefits: ['High Calcium Content', 'Easy Digestion', 'Growth & Development'],
    imageUrl: 'assets/images/prod_7.jpg',
  ),
  const Product(
    id: 5,
    name: 'Millet Energy Drink Mix',
    price: 449,
    category: 'daily-energy',
    rating: 4.6,
    reviews: 92,
    benefits: ['Pre & Post Workout', 'No Caffeine Jitters', 'Complex Carbohydrates'],
    imageUrl: 'assets/images/prod_1.jpg',
  ),
  const Product(
    id: 6,
    name: "Women's Wellness Mix",
    price: 649,
    category: 'womens-wellness',
    rating: 4.9,
    reviews: 143,
    benefits: ['Hormonal Balance', 'Bone Health Support', 'Iron Rich Formulation'],
    imageUrl: 'assets/images/prod_4.jpg',
  ),
  const Product(
    id: 7,
    name: 'Diabetic Care Millet Mix',
    price: 699,
    category: 'weight-management',
    rating: 4.7,
    reviews: 76,
    benefits: ['Blood Sugar Management', 'Zero Added Sugar', 'Slow Release Carbs'],
    imageUrl: 'assets/images/prod_6.jpg',
  ),
  const Product(
    id: 8,
    name: 'Immunity Booster Mix',
    price: 599,
    category: 'family-health',
    rating: 4.8,
    reviews: 134,
    benefits: ['Traditional Herbs Blend', 'Seasonal Protection', 'Respiratory Health'],
    imageUrl: 'assets/images/prod_7.jpg',
  ),
];

final productsProvider = Provider<List<Product>>((ref) {
  return _hardcodedProducts;
});

final productsByCategoryProvider = Provider.family<List<Product>, String>((ref, category) {
  final allProducts = ref.watch(productsProvider);
  if (category == 'all') return allProducts;
  return allProducts.where((p) => p.category == category).toList();
});
