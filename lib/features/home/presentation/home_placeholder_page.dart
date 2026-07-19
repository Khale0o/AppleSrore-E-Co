import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/store_theme_v2.dart';
import '../../../core/accessibility/reduced_motion_controller.dart';
import '../../../shared/widgets/product_image.dart';
import '../../../shared/widgets/store_ui_v2.dart';
import '../../cart/presentation/cart_state.dart';
import '../../saved/presentation/saved_state.dart';
import 'home_products.dart';

class HomePlaceholderPage extends ConsumerStatefulWidget {
  const HomePlaceholderPage({super.key});
  @override
  ConsumerState<HomePlaceholderPage> createState() => _HomeState();
}

class _HomeState extends ConsumerState<HomePlaceholderPage> {
  late final PageController _heroController;
  int selectedHero = 0;

  static const _categoryIcons = [
    Icons.phone_iphone_rounded,
    Icons.laptop_mac_rounded,
    Icons.tablet_mac_rounded,
    Icons.watch_rounded,
    Icons.headphones_rounded,
    Icons.cable_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _heroController = PageController(viewportFraction: 0.93);
  }

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  void _open(HomeProduct product) => context.pushNamed(
    AppRoutes.product,
    pathParameters: {'productId': product.id},
  );

  void _toggleSaved(HomeProduct product) => ref
      .read(savedProvider.notifier)
      .toggle(
        SavedItem(
          productId: product.id,
          variantId: 'default',
          variantName: product.finish,
          imagePath: product.assetPath,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final reduced = ref.watch(reducedMotionProvider);
    final saved = ref.watch(savedProvider);
    final cartCount = ref.watch(cartCountProvider);
    final heroProducts = [homeProducts[0], homeProducts[6], homeProducts[21]];
    final hero = heroProducts[selectedHero];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 12, 8),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AppleStore Concept',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Unofficial portfolio store',
                            style: TextStyle(
                              color: StoreColors.muted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Search',
                      onPressed: () => context.goNamed(AppRoutes.catalog),
                      icon: const Icon(Icons.search_rounded),
                    ),
                    IconButton(
                      tooltip: 'Saved',
                      onPressed: () => context.goNamed(AppRoutes.saved),
                      icon: const Icon(Icons.favorite_border_rounded),
                    ),
                    IconButton(
                      tooltip: 'Cart',
                      onPressed: () => context.goNamed(AppRoutes.cart),
                      icon: Badge(
                        isLabelVisible: cartCount > 0,
                        label: Text('$cartCount'),
                        child: const Icon(Icons.shopping_bag_outlined),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: AnimatedContainer(
                duration: Duration(milliseconds: reduced ? 80 : 260),
                curve: Curves.easeOutCubic,
                color: Color.lerp(const Color(0xFFFFE9EC), hero.accent, 0.12),
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  children: [
                    SizedBox(
                      height: 330,
                      child: PageView.builder(
                        controller: _heroController,
                        itemCount: heroProducts.length,
                        onPageChanged: (index) =>
                            setState(() => selectedHero = index),
                        itemBuilder: (context, index) => _CampaignHero(
                          product: heroProducts[index],
                          onOpen: () => _open(heroProducts[index]),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        heroProducts.length,
                        (index) => AnimatedContainer(
                          duration: Duration(milliseconds: reduced ? 80 : 180),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: selectedHero == index ? 24 : 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: selectedHero == index
                                ? StoreColors.red
                                : Colors.black12,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 102,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  scrollDirection: Axis.horizontal,
                  itemCount: ProductCategory.values.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 4),
                  itemBuilder: (context, index) => CategoryItem(
                    label: ProductCategory.values[index].label,
                    icon: _categoryIcons[index],
                    selected: false,
                    onTap: () => context.goNamed(AppRoutes.catalog),
                  ),
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
              sliver: SliverToBoxAdapter(
                child: StoreSectionHeader(
                  title: 'Flash Deals',
                  actionLabel: '01 : 42 : 18',
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 252,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final product = homeProducts[index + 1];
                    return SizedBox(
                      width: 166,
                      child: StoreProductCard(
                        product: product,
                        saved: saved.any(
                          (item) => item.productId == product.id,
                        ),
                        onSaved: () => _toggleSaved(product),
                        onOpen: () => _open(product),
                        discount: 10 + index * 3,
                        originalPrice: product.basePrice + 120,
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
              sliver: SliverToBoxAdapter(
                child: StoreSectionHeader(
                  title: 'Best Selling',
                  actionLabel: 'See All',
                  onAction: () => context.goNamed(AppRoutes.catalog),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 250,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final product = homeProducts[[0, 6, 13, 18][index]];
                  return StoreProductCard(
                    product: product,
                    saved: saved.any((item) => item.productId == product.id),
                    onSaved: () => _toggleSaved(product),
                    onOpen: () => _open(product),
                  );
                }, childCount: 4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CampaignHero extends StatelessWidget {
  const _CampaignHero({required this.product, required this.onOpen});
  final HomeProduct product;
  final VoidCallback onOpen;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: ColoredBox(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 12, 16),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'LIMITED CAMPAIGN',
                      style: TextStyle(
                        color: StoreColors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.name,
                      maxLines: 3,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.tagline,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: onOpen,
                      child: const Text('Shop now'),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 6,
                child: Hero(
                  tag: product.heroTag,
                  child: ProductImage(
                    path: product.assetPath,
                    label: product.name,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
