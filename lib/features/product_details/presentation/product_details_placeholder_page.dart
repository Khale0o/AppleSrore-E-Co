import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/design_system/app_scaffold.dart';
import '../../../app/design_system/app_text_button.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/accessibility/reduced_motion_controller.dart';
import '../../home/presentation/home_products.dart';
import '../../home/presentation/production_phone_render.dart';

class ProductDetailsPlaceholderPage extends ConsumerWidget {
  const ProductDetailsPlaceholderPage({super.key, required this.productId});
  final String productId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = productForIdOrNull(productId);
    if (product == null) {
      return _Fallback(onHome: () => context.goNamed(AppRoutes.home));
    }
    final reduced = ref.watch(reducedMotionProvider);
    return AppScaffold(
      padding: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [product.start, product.end],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 96),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      key: const Key('details_back'),
                      onPressed: () => context.pop(),
                      color: Colors.white,
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Hero(
                        tag: product.heroTag,
                        child: SizedBox(
                          width: 190,
                          child: ProductionPhoneRender(product: product),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(product.name, style: AppTypography.headline),
                    const SizedBox(height: 8),
                    Text(
                      product.tagline,
                      style: TextStyle(color: product.accent, fontSize: 17),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '${product.finish} · ${product.price}',
                      style: AppTypography.body,
                    ),
                    const SizedBox(height: 28),
                    ...product.features.asMap().entries.map(
                      (entry) => TweenAnimationBuilder<double>(
                        tween: Tween(begin: reduced ? 1 : 0, end: 1),
                        duration: Duration(
                          milliseconds: reduced ? 100 : 180 + entry.key * 55,
                        ),
                        builder: (context, value, child) => Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, reduced ? 0 : 12 * (1 - value)),
                            child: child,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            '— ${entry.value}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: .75),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 24,
                right: 24,
                bottom: 16,
                child: AppTextButton(
                  label: 'Configure',
                  onPressed: () => context.pushNamed(
                    AppRoutes.configure,
                    pathParameters: {'productId': product.id},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({required this.onHome});
  final VoidCallback onHome;
  @override
  Widget build(BuildContext context) => AppScaffold(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        const Text('PRODUCT UNAVAILABLE', style: AppTypography.label),
        const SizedBox(height: 12),
        const Text(
          'This product is not in the current collection.',
          style: AppTypography.headline,
        ),
        const Spacer(),
        AppTextButton(label: 'Back Home', onPressed: onHome),
      ],
    ),
  );
}
