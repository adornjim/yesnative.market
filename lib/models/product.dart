class Product {
  final int id;
  final String name;
  final double price;
  final String category;
  final String? imagePath;
  final double rating;
  final int reviews;
  final List<String> benefits;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    this.imagePath,
    required this.rating,
    required this.reviews,
    required this.benefits,
  });
}
