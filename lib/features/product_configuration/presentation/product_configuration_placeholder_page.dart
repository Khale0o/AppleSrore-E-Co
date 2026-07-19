import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/app_routes.dart';
import '../../../core/accessibility/reduced_motion_controller.dart';
import '../../../shared/widgets/product_image.dart';
import '../../cart/presentation/cart_badge.dart';
import '../../cart/presentation/cart_state.dart';
import '../../home/presentation/home_products.dart';

class ProductConfigurationPlaceholderPage extends ConsumerStatefulWidget {
  const ProductConfigurationPlaceholderPage({
    super.key,
    required this.productId,
  });
  final String productId;
  @override
  ConsumerState<ProductConfigurationPlaceholderPage> createState() =>
      _ConfigState();
}

class _ConfigState extends ConsumerState<ProductConfigurationPlaceholderPage>
    with TickerProviderStateMixin {
  int finish = 0, config = 0;
  bool showing = false;
  late final AnimationController _flightController;
  late final AnimationController _pulseController;
  OverlayEntry? _flightEntry;
  final _productKey = GlobalKey();
  final _bagKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _flightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 190),
      lowerBound: 0,
      upperBound: 1,
    );
  }

  @override
  void dispose() {
    _flightEntry?.remove();
    _flightEntry = null;
    _flightController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) {
    final p = productForIdOrNull(widget.productId);
    if (p == null) {
      return const Scaffold(body: Center(child: Text('PRODUCT UNAVAILABLE')));
    }
    final reduced = ref.watch(reducedMotionProvider);
    final lighting = Color.lerp(p.start, p.accent, 0.06 + finish * 0.035)!;
    return Scaffold(
      backgroundColor: p.start,
      body: AnimatedContainer(
        duration: Duration(milliseconds: reduced ? 80 : 220),
        curve: Curves.easeOutCubic,
        color: lighting,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => c.pop(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Spacer(),
                    ScaleTransition(
                      key: _bagKey,
                      scale: Tween<double>(begin: 1, end: 1.12).animate(
                        CurvedAnimation(
                          parent: _pulseController,
                          curve: Curves.easeOutBack,
                        ),
                      ),
                      child: const CartBadge(),
                    ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: SizedBox(
                      key: _productKey,
                      child: ProductImage(
                        path: p.assetPath,
                        label: p.name,
                        heroTag: p.heroTag,
                      ),
                    ),
                  ),
                ),
                Text(
                  'Configure ${p.name}',
                  style: const TextStyle(color: Colors.white, fontSize: 28),
                ),
                Wrap(
                  children: List.generate(
                    p.finishes.length,
                    (i) => ChoiceChip(
                      label: Text(p.finishes[i]),
                      selected: finish == i,
                      onSelected: (_) => setState(() => finish = i),
                    ),
                  ),
                ),
                Wrap(
                  children: List.generate(
                    p.configurations.length,
                    (i) => ChoiceChip(
                      label: Text(p.configurations[i]),
                      selected: config == i,
                      onSelected: (_) => setState(() => config = i),
                    ),
                  ),
                ),
                FilledButton(
                  key: const Key('add_to_bag'),
                  onPressed: () => _add(c, p),
                  child: Text('Add to Bag \$${p.basePrice + config * 100}'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _add(BuildContext c, HomeProduct p) {
    ref
        .read(cartProvider.notifier)
        .add(
          CartItem(
            productId: p.id,
            name: p.name,
            finish: p.finishes[finish],
            storage: p.configurations[config],
            unitPrice: p.basePrice + config * 100,
          ),
        );
    _runFlight(p, ref.read(reducedMotionProvider));
    if (showing) return;
    showing = true;
    showModalBottomSheet<void>(
      context: c,
      builder: (c) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Added to Bag'),
            Text(p.name),
            TextButton(
              onPressed: () => c.goNamed(AppRoutes.cart),
              child: const Text('Open Cart'),
            ),
          ],
        ),
      ),
    ).whenComplete(() => showing = false);
  }

  Future<void> _runFlight(HomeProduct product, bool reduced) async {
    if (reduced || _flightController.isAnimating || _flightEntry != null) {
      return;
    }
    final startBox =
        _productKey.currentContext?.findRenderObject() as RenderBox?;
    final endBox = _bagKey.currentContext?.findRenderObject() as RenderBox?;
    if (startBox == null ||
        endBox == null ||
        !startBox.hasSize ||
        !endBox.hasSize) {
      return;
    }
    final start = startBox.localToGlobal(startBox.size.center(Offset.zero));
    final end = endBox.localToGlobal(endBox.size.center(Offset.zero));
    _flightEntry = OverlayEntry(
      builder: (context) => IgnorePointer(
        child: AnimatedBuilder(
          animation: _flightController,
          builder: (context, child) {
            final t = Curves.easeInOutCubic.transform(_flightController.value);
            final direct = Offset.lerp(start, end, t)!;
            final arc = Offset(0, -72 * 4 * t * (1 - t));
            return Stack(
              children: [
                Positioned(
                  left: direct.dx + arc.dx - 24,
                  top: direct.dy + arc.dy - 34,
                  child: Opacity(
                    opacity: 1 - t * 0.25,
                    child: Transform.scale(
                      scale: 1 - t * 0.55,
                      child: SizedBox(
                        width: 48,
                        height: 68,
                        child: ProductImage(
                          path: product.assetPath,
                          label: product.name,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(_flightEntry!);
    await _flightController.forward(from: 0);
    _flightEntry?.remove();
    _flightEntry = null;
    if (!mounted || reduced) return;
    await _pulseController.forward(from: 0);
    if (mounted) await _pulseController.reverse();
  }
}
