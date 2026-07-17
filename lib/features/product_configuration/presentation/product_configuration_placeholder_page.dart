import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/design_system/app_scaffold.dart';
import '../../../app/design_system/app_text_button.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_motion.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/accessibility/reduced_motion_controller.dart';
import '../../home/presentation/home_products.dart';
import '../../home/presentation/production_phone_render.dart';
import '../../cart/presentation/cart_state.dart';
import '../../cart/presentation/cart_badge.dart';

class ProductConfigurationPlaceholderPage extends ConsumerStatefulWidget {
  const ProductConfigurationPlaceholderPage({
    super.key,
    required this.productId,
  });
  final String productId;
  @override
  ConsumerState<ProductConfigurationPlaceholderPage> createState() =>
      _ProductConfigurationPlaceholderPageState();
}

class _ProductConfigurationPlaceholderPageState
    extends ConsumerState<ProductConfigurationPlaceholderPage>
    with SingleTickerProviderStateMixin {
  int _color = 0, _storage = 0;
  static const finishes = ['Graphite', 'Frost Silver', 'Arctic Blue'];
  static const storage = ['128 GB', '256 GB', '512 GB'];
  static const increments = [0, 100, 250];
  bool _showingConfirmation = false;
  late final AnimationController _flight;
  OverlayEntry? _flightEntry;
  final _productKey = GlobalKey();
  final _bagKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _flight = AnimationController(vsync: this, duration: AppMotion.emphasis);
  }

  @override
  void dispose() {
    _flightEntry?.remove();
    _flight.dispose();
    super.dispose();
  }

  void _runFlight(HomeProduct product, bool reduced) {
    if (reduced || _flight.isAnimating) return;
    final start = (_productKey.currentContext?.findRenderObject() as RenderBox?)
        ?.localToGlobal(Offset.zero);
    final end = (_bagKey.currentContext?.findRenderObject() as RenderBox?)
        ?.localToGlobal(Offset.zero);
    if (start == null || end == null) return;
    _flightEntry = OverlayEntry(
      builder: (context) => AnimatedBuilder(
        animation: _flight,
        builder: (context, _) {
          final t = Curves.easeInOutCubic.transform(_flight.value);
          final pos =
              Offset.lerp(start, end, t)! + Offset(0, -70 * 4 * t * (1 - t));
          return Positioned(
            left: pos.dx,
            top: pos.dy,
            child: Opacity(
              opacity: 1 - t * .35,
              child: Transform.scale(
                scale: 1 - t * .55,
                child: SizedBox(
                  width: 48,
                  child: ProductionPhoneRender(product: product),
                ),
              ),
            ),
          );
        },
      ),
    );
    Overlay.of(context).insert(_flightEntry!);
    _flight.forward(from: 0).whenComplete(() => _flightEntry?.remove());
  }

  void _add(HomeProduct product) {
    final item = CartItem(
      productId: product.id,
      name: product.name,
      finish: product.finish,
      storage: storage[_storage],
      unitPrice: product.basePrice + increments[_storage],
    );
    ref.read(cartProvider.notifier).add(item);
    _runFlight(product, ref.read(reducedMotionProvider));
    if (_showingConfirmation) return;
    _showingConfirmation = true;
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Added to Bag', style: AppTypography.title),
            Text('${item.name} · ${item.finish} · ${item.storage}'),
            AppTextButton(
              label: 'Continue Exploring',
              onPressed: () => Navigator.pop(context),
            ),
            AppTextButton(
              label: 'Open Cart',
              onPressed: () => context.goNamed(AppRoutes.cart),
            ),
          ],
        ),
      ),
    ).whenComplete(() => _showingConfirmation = false);
  }

  @override
  Widget build(BuildContext context) {
    final base = productForIdOrNull(widget.productId);
    if (base == null) {
      return _ConfigFallback(onHome: () => context.goNamed(AppRoutes.home));
    }
    final reduced = ref.watch(reducedMotionProvider);
    final accents = [
      base.accent,
      const Color(0xFFCFE9F2),
      const Color(0xFF9DBFFF),
    ];
    final configured = HomeProduct(
      id: base.id,
      name: base.name,
      finish: finishes[_color],
      tagline: base.tagline,
      metadata: base.metadata,
      price: 'From ${base.basePrice + increments[_storage]}',
      start: base.start,
      end: base.end,
      accent: accents[_color],
      cameraCount: base.cameraCount,
      widthFactor: base.widthFactor,
      features: base.features,
      basePrice: base.basePrice,
    );
    return AppScaffold(
      padding: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [configured.start, configured.end]),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      color: Colors.white,
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    const Spacer(),
                    CartBadge(key: _bagKey),
                  ],
                ),
                Center(
                  child: AnimatedSwitcher(
                    duration: reduced ? AppMotion.instant : AppMotion.standard,
                    child: Hero(
                      key: _productKey,
                      tag: configured.heroTag,
                      child: SizedBox(
                        width: 155,
                        child: ProductionPhoneRender(product: configured),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(configured.name, style: AppTypography.headline),
                const SizedBox(height: 6),
                Text(
                  configured.finish,
                  style: TextStyle(color: configured.accent, fontSize: 16),
                ),
                const SizedBox(height: 24),
                const Text('Finish', style: AppTypography.label),
                Wrap(
                  spacing: 8,
                  children: List.generate(
                    3,
                    (i) => ChoiceChip(
                      key: Key('color_$i'),
                      label: Text(finishes[i]),
                      selected: _color == i,
                      onSelected: (_) => setState(() => _color = i),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Storage', style: AppTypography.label),
                Wrap(
                  spacing: 8,
                  children: List.generate(
                    3,
                    (i) => ChoiceChip(
                      key: Key('storage_$i'),
                      label: Text(storage[i]),
                      selected: _storage == i,
                      onSelected: (_) => setState(() => _storage = i),
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                AnimatedSwitcher(
                  duration: reduced ? AppMotion.instant : AppMotion.fast,
                  child: Text(
                    'From ${base.basePrice + increments[_storage]}',
                    key: ValueKey(_storage),
                    style: AppTypography.headline,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${configured.finish} · ${storage[_storage]}',
                  style: AppTypography.body,
                ),
                const SizedBox(height: 22),
                AppTextButton(
                  key: const Key('add_to_bag'),
                  label: 'Add to Bag',
                  onPressed: () => _add(configured),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConfigFallback extends StatelessWidget {
  const _ConfigFallback({required this.onHome});
  final VoidCallback onHome;
  @override
  Widget build(BuildContext context) => AppScaffold(
    child: Column(
      children: [
        const Spacer(),
        const Text('PRODUCT UNAVAILABLE', style: AppTypography.label),
        const Spacer(),
        AppTextButton(label: 'Back Home', onPressed: onHome),
      ],
    ),
  );
}
