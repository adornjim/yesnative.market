import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:badges/badges.dart' as badges;
import '../core/theme/app_colors.dart';
import '../providers/cart_provider.dart';

class AppScaffold extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppScaffold({
    super.key,
    required this.navigationShell,
  });

  @override
  ConsumerState<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends ConsumerState<AppScaffold> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _controller.forward(from: 0.0);
  }

  @override
  void didUpdateWidget(AppScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.navigationShell.currentIndex != oldWidget.navigationShell.currentIndex) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = ref.watch(cartCountProvider);

    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final curveValue = CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart).value;
          return Opacity(
            opacity: _controller.value,
            child: Transform.translate(
              offset: Offset(0, 15 * (1 - curveValue)),
              child: child,
            ),
          );
        },
        child: widget.navigationShell,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.navigationShell.currentIndex,
        onTap: _goBranch,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.spa_outlined),
            activeIcon: Icon(Icons.spa),
            label: 'Wellness',
          ),
          BottomNavigationBarItem(
            icon: badges.Badge(
              showBadge: cartCount > 0,
              badgeContent: Text(cartCount.toString(), style: const TextStyle(color: Colors.white, fontSize: 10)),
              position: badges.BadgePosition.topEnd(top: -12, end: -12),
              badgeStyle: const badges.BadgeStyle(badgeColor: AppColors.error),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            activeIcon: badges.Badge(
              showBadge: cartCount > 0,
              badgeContent: Text(cartCount.toString(), style: const TextStyle(color: Colors.white, fontSize: 10)),
              position: badges.BadgePosition.topEnd(top: -12, end: -12),
              badgeStyle: const badges.BadgeStyle(badgeColor: AppColors.error),
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}


