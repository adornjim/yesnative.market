import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishlistNotifier extends Notifier<List<int>> {
  @override
  List<int> build() {
    return [];
  }

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

final wishlistProvider = NotifierProvider<WishlistNotifier, List<int>>(() {
  return WishlistNotifier();
});
