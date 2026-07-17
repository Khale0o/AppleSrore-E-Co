import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/app_routes.dart';
import '../../../core/accessibility/reduced_motion_controller.dart';
import '../../cart/presentation/cart_badge.dart';
import 'home_products.dart';

class HomePlaceholderPage extends ConsumerWidget {
  const HomePlaceholderPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flagship = homeProducts.first;
    final reduced = ref.watch(reducedMotionProvider);
    final featured = homeProducts.where((p) => p.featured).toList();
    return Scaffold(
      backgroundColor: const Color(0xFF07090D),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    const Text(
                      'APPLestore',
                      style: TextStyle(color: Colors.white, letterSpacing: 2),
                    ),
                    const Spacer(),
                    const CartBadge(),
                    Switch(
                      key: const Key('reduced_motion_toggle'),
                      value: reduced,
                      onChanged: (_) => ref
                          .read(reducedMotionControllerProvider.notifier)
                          .toggleDevelopmentOverride(),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _Hero(product: flagship, reduced: reduced),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: ProductCategory.values
                      .map(
                        (c) => Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: TextButton(
                            onPressed: () =>
                                context.pushNamed(AppRoutes.catalog),
                            child: Text(c.label),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Featured across the ecosystem',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: Colors.white),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 270,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(24),
                  itemCount: featured.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 14),
                  itemBuilder: (c, i) => SizedBox(
                    width: 230,
                    child: _Featured(product: featured[i]),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'One ecosystem. A quieter, more connected way to work, create, and move.',
                  style: TextStyle(color: Colors.white70, fontSize: 20),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Unofficial portfolio concept. Product names and imagery belong to their respective owners.',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.product, required this.reduced});
  final HomeProduct product;
  final bool reduced;
  @override
  Widget build(BuildContext c) => Padding(
    padding: const EdgeInsets.all(24),
    child: Container(
      height: 430,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [product.start, product.end]),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'INTRODUCING',
              style: TextStyle(color: product.accent, letterSpacing: 2),
            ),
            Text(
              product.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              product.tagline,
              style: const TextStyle(color: Colors.white70),
            ),
            Expanded(
              child: Hero(
                tag: product.heroTag,
                child: Image.asset(
                  product.assetPath,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(
                      Icons.image_outlined,
                      color: Colors.white38,
                      size: 90,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                FilledButton(
                  onPressed: () => c.pushNamed(
                    AppRoutes.product,
                    pathParameters: {'productId': product.id},
                  ),
                  child: const Text('Explore'),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () => c.pushNamed(
                    AppRoutes.configure,
                    pathParameters: {'productId': product.id},
                  ),
                  child: const Text('Configure'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _Featured extends StatelessWidget {
  const _Featured({required this.product});
  final HomeProduct product;
  @override
  Widget build(BuildContext c) => InkWell(
    onTap: () => c.pushNamed(
      AppRoutes.product,
      pathParameters: {'productId': product.id},
    ),
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: product.end,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Hero(
              tag: 'featured-${product.id}',
              child: Image.asset(
                product.assetPath,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image_outlined,
                  color: Colors.white38,
                  size: 60,
                ),
              ),
            ),
          ),
          Text(
            product.category.label.toUpperCase(),
            style: TextStyle(color: product.accent, fontSize: 11),
          ),
          Text(
            product.name,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    ),
  );
}
