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
    extends ConsumerState<ProductConfigurationPlaceholderPage> {
  int _color = 0, _storage = 0;
  static const finishes = ['Graphite', 'Frost Silver', 'Arctic Blue'];
  static const storage = ['128 GB', '256 GB', '512 GB'];
  static const increments = [0, 100, 250];
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
                IconButton(
                  onPressed: () => context.pop(),
                  color: Colors.white,
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
                Center(
                  child: AnimatedSwitcher(
                    duration: reduced ? AppMotion.instant : AppMotion.standard,
                    child: Hero(
                      key: ValueKey(_color),
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
                AppTextButton(label: 'Add to Bag', onPressed: () {}),
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
