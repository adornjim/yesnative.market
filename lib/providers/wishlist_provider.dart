import 'package:flutter_riverpod/flutter_riverpod.dart';

final wishlistProvider = StateNotifierProvider<WishlistNotifier, List<int>>((ref) {
  return WishlistNotifier();
});

class WishlistNotifier extends StateNotifier<List<int>> {
  WishlistNotifier() : super([]);

  void toggleFavorite(int productId) {
    if (state.contains(productId)) {
      state = state.where((id) => id != productId).toList();
    } else {
      state = [...state, productId];
    }
  }

  bool isFavorite(int productId) {
    return state.contains(productId);
  }
}
