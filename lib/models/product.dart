class Product {
  final int id;
  final String name;
  final double price;
  final String category;
  final double rating;
  final int reviews;
  final List<String> benefits;
  final String? imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.rating,
    required this.reviews,
    required this.benefits,
    this.imageUrl,
  });
}
