import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/app_routes.dart';
import '../../../core/accessibility/reduced_motion_controller.dart';
import '../../../shared/widgets/product_image.dart';
import '../../cart/presentation/cart_badge.dart';
import '../../home/presentation/home_products.dart';

class ProductDetailsPlaceholderPage extends ConsumerWidget {
  const ProductDetailsPlaceholderPage({super.key, required this.productId});
  final String productId;
  @override
  Widget build(BuildContext c, WidgetRef ref) {
    final p = productForIdOrNull(productId);
    if (p == null) {
      return const Scaffold(body: Center(child: Text('PRODUCT UNAVAILABLE')));
    }
    final related = homeProducts
        .where((x) => x.category == p.category && x.id != p.id)
        .take(3);
    final reduced = ref.watch(reducedMotionProvider);
    return Scaffold(
      backgroundColor: p.start,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => c.pop(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Spacer(),
                    const CartBadge(),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                        height: 260,
                        child: ProductImage(
                          path: p.assetPath,
                          label: p.name,
                          heroTag: p.heroTag,
                        ),
                      ),
                    ),
                    _DetailsReveal(
                      reduced: reduced,
                      order: 0,
                      child: Text(
                        p.category.label.toUpperCase(),
                        style: TextStyle(color: p.accent, letterSpacing: 2),
                      ),
                    ),
                    _DetailsReveal(
                      reduced: reduced,
                      order: 1,
                      child: Text(
                        p.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                        ),
                      ),
                    ),
                    Text(
                      p.tagline,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _DetailsReveal(
                      reduced: reduced,
                      order: 2,
                      child: Text(
                        p.price,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...p.features.map(
                      (f) => _DetailsReveal(
                        reduced: reduced,
                        order: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            '— $f',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      children: p.finishes
                          .map((f) => Chip(label: Text(f)))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    _DetailsReveal(
                      reduced: reduced,
                      order: 4,
                      child: FilledButton(
                        onPressed: () => c.pushNamed(
                          AppRoutes.configure,
                          pathParameters: {'productId': p.id},
                        ),
                        child: const Text('Configure'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'More ${p.category.label}',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: related
                      .map(
                        (x) => TextButton(
                          onPressed: () => c.pushNamed(
                            AppRoutes.product,
                            pathParameters: {'productId': x.id},
                          ),
                          child: Text(x.name),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsReveal extends StatelessWidget {
  const _DetailsReveal({
    required this.reduced,
    required this.order,
    required this.child,
  });

  final bool reduced;
  final int order;
  final Widget child;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: reduced ? 1 : 0, end: 1),
    duration: Duration(milliseconds: reduced ? 80 : 260 + order * 70),
    curve: Curves.easeOutCubic,
    child: child,
    builder: (context, value, child) => Opacity(
      opacity: value,
      child: Transform.translate(
        offset: Offset(0, reduced ? 0 : 14 * (1 - value)),
        child: child,
      ),
    ),
  );
}
