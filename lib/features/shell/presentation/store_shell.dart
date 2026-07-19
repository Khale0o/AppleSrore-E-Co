import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/store_theme_v2.dart';
import '../../cart/presentation/cart_state.dart';
import '../../saved/presentation/saved_state.dart';

class StoreShell extends ConsumerWidget {
  const StoreShell({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartCountProvider);
    final savedCount = ref.watch(savedCountProvider);
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: navigationShell,
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Align(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (index) => navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              ),
              destinations: [
                const NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(
                    Icons.home_rounded,
                    color: StoreColors.red,
                  ),
                  label: 'Home',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.grid_view_outlined),
                  selectedIcon: Icon(
                    Icons.grid_view_rounded,
                    color: StoreColors.red,
                  ),
                  label: 'Explore',
                ),
                NavigationDestination(
                  icon: Badge(
                    isLabelVisible: savedCount > 0,
                    label: Text('$savedCount'),
                    child: const Icon(Icons.favorite_border_rounded),
                  ),
                  selectedIcon: const Icon(
                    Icons.favorite_rounded,
                    color: StoreColors.red,
                  ),
                  label: 'Saved',
                ),
                NavigationDestination(
                  icon: Badge(
                    isLabelVisible: cartCount > 0,
                    label: Text('$cartCount'),
                    child: const Icon(Icons.shopping_bag_outlined),
                  ),
                  selectedIcon: const Icon(
                    Icons.shopping_bag_rounded,
                    color: StoreColors.red,
                  ),
                  label: 'Cart',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  selectedIcon: Icon(
                    Icons.person_rounded,
                    color: StoreColors.red,
                  ),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
