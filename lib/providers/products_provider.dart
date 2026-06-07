import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../core/api/api_client.dart';

final List<Product> _hardcodedProducts = [
  const Product(
    id: 1,
    name: 'Black Rice Choco Drink Mix',
    price: 499,
    category: 'family-health',
    rating: 4.8,
    reviews: 124,
    benefits: ['Rich in Antioxidants', 'Kid-Friendly Taste', 'Immunity Boosting'],
    description: 'A delicious and highly nutritious drink mix made from traditional black rice. Perfect for the whole family, this choco-flavored drink offers the goodness of antioxidants and essential minerals while satisfying your chocolate cravings naturally.',
    imageUrl: 'assets/images/Black Rice Choco Drink Mix.jpeg',
    additionalImages: ['assets/images/Black Rice Choco Drink Mix Ingredients.jpeg'],
  ),
  const Product(
    id: 2,
    name: 'Instant Millet Energy Drink Chocolate',
    price: 349,
    category: 'daily-energy',
    rating: 4.9,
    reviews: 198,
    benefits: ['Pre & Post Workout', 'No Caffeine Jitters', 'Complex Carbohydrates'],
    description: 'Recharge your day with our Instant Millet Energy Drink. Crafted with a premium blend of native millets and natural chocolate, it provides sustained energy without the sugar crash.',
    imageUrl: 'assets/images/Instant Millet Energy Drink Chocolate.jpeg',
    additionalImages: ['assets/images/Instant Millet Energy Drink Chocolate Ingredients.jpeg'],
  ),
  const Product(
    id: 3,
    name: 'Instant Millet Energy Drink Mix',
    price: 299,
    category: 'daily-energy',
    rating: 4.6,
    reviews: 92,
    benefits: ['Sustained Energy Release', 'High in Dietary Fiber', 'Easy to Digest'],
    description: 'The classic unflavored Instant Millet Energy Drink Mix. Packed with traditional grains, it is the perfect base for your morning smoothies or a quick wholesome drink to keep you active.',
    imageUrl: 'assets/images/Instant Millet Energy Drink Mix.jpeg',
  ),
  const Product(
    id: 4,
    name: 'Millet Energy Drink Red Banana',
    price: 399,
    category: 'daily-energy',
    rating: 4.8,
    reviews: 156,
    benefits: ['Potassium Rich', 'Natural Sweetness', 'Heart Health'],
    description: 'Experience the unique taste and health benefits of Red Banana paired with our signature millet blend. A naturally sweet, potassium-rich drink that fuels your body with pure goodness.',
    imageUrl: 'assets/images/Instant Millet Energy Drink Red Banana.jpeg',
  ),
  const Product(
    id: 5,
    name: 'Red Banana Enriched Drink',
    price: 449,
    category: 'natural-nourishment',
    rating: 4.9,
    reviews: 143,
    benefits: ['Enhanced Nutrient Profile', 'High Fiber', 'Muscle Recovery'],
    description: 'Our premium enriched version of the Red Banana Millet drink. Fortified with additional native grains and nuts to provide an extra boost of essential vitamins and minerals for optimal wellness.',
    imageUrl: 'assets/images/Instant Millet Energy Drink Red Banana Enriched.jpeg',
  ),
  const Product(
    id: 6,
    name: 'Pamcube Badam Drink Mix',
    price: 599,
    category: 'natural-nourishment',
    rating: 4.7,
    reviews: 87,
    benefits: ['Natural Sweetener', 'Rich in Vitamin E', 'Brain Health Support'],
    description: 'A luxurious Badam (Almond) drink mix sweetened naturally with Palm Sugar (Pamcube). This traditional recipe supports cognitive function and provides healthy fats in a comforting, warm beverage.',
    imageUrl: 'assets/images/Pamcube Badam Drink Mix.jpeg',
  ),
  const Product(
    id: 7,
    name: 'Sprouted Ragi Choco Malt',
    price: 549,
    category: 'kids-nutrition',
    rating: 4.8,
    reviews: 134,
    benefits: ['High Calcium Content', 'Easy Digestion', 'Growth & Development'],
    description: 'Specially crafted for growing children (and loved by adults!), this Sprouted Ragi Choco Malt is rich in calcium and iron. Sprouting enhances nutrient absorption, making it the perfect daily nutritional supplement.',
    imageUrl: 'assets/images/Sprouted Ragi Choco Malt.jpeg',
    additionalImages: ['assets/images/Sprouted Ragi Choco Malt Ingredients.jpeg'],
  ),
  const Product(
    id: 8,
    name: 'SlimSure Wellness Mix',
    price: 499,
    category: 'weight-management',
    rating: 4.7,
    reviews: 76,
    benefits: ['Weight Management', 'Zero Added Sugar', 'Slow Release Carbs'],
    description: 'Our special blend designed to support healthy weight management and stable blood sugar levels. Formulated with carefully selected complex carbohydrates and fiber.',
    imageUrl: 'assets/images/Instant Millet Energy Drink Mix.jpeg',
  ),
];

class ProductsNotifier extends Notifier<List<Product>> {
  @override
  List<Product> build() {
    _fetchProducts();
    return _hardcodedProducts; // Fallback / initial state while loading
  }

  Future<void> _fetchProducts() async {
    try {
      final data = await ApiClient.get('/products/public');
      final fetchedProducts = (data as List).map((e) => Product(
        id: e['id'],
        name: e['name'],
        price: (e['price'] as num).toDouble(),
        category: e['category'],
        rating: (e['rating'] as num).toDouble(),
        reviews: e['reviews'],
        benefits: List<String>.from(e['benefits'] ?? []),
        description: e['description'] ?? '',
        imageUrl: e['imageUrl'],
        additionalImages: List<String>.from(e['additionalImages'] ?? []),
      )).toList();
      
      if (fetchedProducts.isNotEmpty) {
        state = fetchedProducts;
      } else {
        // Fallback to hardcoded products if the database is empty
        state = _hardcodedProducts;
      }
    } catch (e) {
      print('Failed to fetch products: $e');
    }
  }
}

final productsProvider = NotifierProvider<ProductsNotifier, List<Product>>(() {
  return ProductsNotifier();
});

final productsByCategoryProvider = Provider.family<List<Product>, String>((ref, category) {
  final allProducts = ref.watch(productsProvider);
  if (category == 'all') return allProducts;
  return allProducts.where((p) => p.category == category).toList();
});
