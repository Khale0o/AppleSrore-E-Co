import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/store_theme_v2.dart';
import '../../../core/accessibility/reduced_motion_controller.dart';
import '../../../shared/widgets/product_image.dart';
import '../../home/presentation/home_products.dart';
import '../../product_details/presentation/product_variants.dart';
import '../application/onboarding_store.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key, this.preview = false});
  final bool preview;

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late final PageController _controller;
  int _index = 0;
  int _variantIndex = 0;
  bool _moving = false;
  bool _finishing = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = ref.watch(reducedMotionProvider);
    return PopScope(
      canPop: widget.preview && _index == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _index > 0) _goTo(_index - 1, reduced);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFC),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
                child: Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      key: const Key('onboarding_skip'),
                      onPressed: _finishing ? null : _finish,
                      child: const Text('Skip'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  key: const Key('onboarding_pages'),
                  controller: _controller,
                  onPageChanged: (value) => setState(() => _index = value),
                  children: [
                    _ScenePage(
                      pageController: _controller,
                      pageIndex: 0,
                      active: _index == 0,
                      reduced: reduced,
                      number: '01',
                      heading: 'DISCOVER',
                      title: 'Everything you love.\nIn one place.',
                      body:
                          'Explore phones, tablets, computers, wearables, audio, and accessories.',
                      visual: _EcosystemScene(
                        active: _index == 0,
                        reduced: reduced,
                      ),
                    ),
                    _ScenePage(
                      pageController: _controller,
                      pageIndex: 1,
                      active: _index == 1,
                      reduced: reduced,
                      number: '02',
                      heading: 'MAKE IT YOURS',
                      title: 'Choose every detail.',
                      body:
                          'Select the finish, size, capacity, and configuration that fits you.',
                      visual: _CustomizationScene(
                        index: _variantIndex,
                        reduced: reduced,
                        onSelected: (value) =>
                            setState(() => _variantIndex = value),
                      ),
                    ),
                    _ScenePage(
                      pageController: _controller,
                      pageIndex: 2,
                      active: _index == 2,
                      reduced: reduced,
                      number: '03',
                      heading: 'FROM DISCOVERY TO DELIVERY',
                      title: 'From discovery\nto delivery.',
                      body:
                          'Save favorites, build your bag, and complete a smooth simulated checkout.',
                      visual: _CommerceScene(
                        active: _index == 2,
                        reduced: reduced,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
                child: Column(
                  children: [
                    _PageIndicator(index: _index, reduced: reduced),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        if (_index > 0) ...[
                          Expanded(
                            child: OutlinedButton(
                              key: const Key('onboarding_back'),
                              onPressed: _moving || _finishing
                                  ? null
                                  : () => _goTo(_index - 1, reduced),
                              child: const Text('Back'),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Expanded(
                          flex: 2,
                          child: FilledButton(
                            key: Key(
                              _index == 2
                                  ? 'onboarding_start'
                                  : 'onboarding_next',
                            ),
                            onPressed: _moving || _finishing
                                ? null
                                : _index == 2
                                ? _finish
                                : () => _goTo(_index + 1, reduced),
                            child: Text(
                              _index == 2 ? 'Start exploring' : 'Next',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _goTo(int page, bool reduced) async {
    if (_moving || !_controller.hasClients) return;
    _moving = true;
    if (reduced) {
      _controller.jumpToPage(page);
    } else {
      await _controller.animateToPage(
        page,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    }
    if (mounted) setState(() => _moving = false);
  }

  Future<void> _finish() async {
    if (_finishing) return;
    setState(() => _finishing = true);
    await ref.read(onboardingStoreProvider).complete();
    if (!mounted) return;
    if (widget.preview && context.canPop()) {
      context.pop();
    } else {
      context.goNamed(AppRoutes.home);
    }
  }
}

class _ScenePage extends StatelessWidget {
  const _ScenePage({
    required this.pageController,
    required this.pageIndex,
    required this.active,
    required this.reduced,
    required this.number,
    required this.heading,
    required this.title,
    required this.body,
    required this.visual,
  });
  final PageController pageController;
  final int pageIndex;
  final bool active, reduced;
  final String number, heading, title, body;
  final Widget visual;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final visualHeight = (constraints.maxHeight * 0.57).clamp(280.0, 400.0);
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    number,
                    style: const TextStyle(
                      color: StoreColors.red,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Container(width: 58, height: 1, color: StoreColors.line),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                heading,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 30,
                  height: 1.02,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              AnimatedSlide(
                duration: Duration(milliseconds: reduced ? 0 : 380),
                curve: Curves.easeOutCubic,
                offset: active || reduced ? Offset.zero : const Offset(0, 0.03),
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: reduced ? 60 : 320),
                  opacity: active ? 1 : 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        key: ValueKey(title),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: StoreColors.muted,
                          fontSize: 22,
                          height: 1.25,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        body,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: StoreColors.muted,
                          height: 1.4,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: pageController,
                child: SizedBox(height: visualHeight, child: visual),
                builder: (context, child) {
                  final page = pageController.hasClients
                      ? pageController.page ?? pageIndex.toDouble()
                      : pageIndex.toDouble();
                  final delta = (page - pageIndex).clamp(-1.0, 1.0);
                  final distance = delta.abs();
                  if (reduced) {
                    return AnimatedOpacity(
                      duration: const Duration(milliseconds: 90),
                      opacity: active ? 1 : 0.75,
                      child: child,
                    );
                  }
                  return Opacity(
                    opacity: 1 - distance * 0.22,
                    child: Transform.translate(
                      offset: Offset(delta * 20, distance * 5),
                      child: Transform.scale(
                        scale: 1 - distance * 0.035,
                        child: child,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      );
    },
  );
}

class _EcosystemScene extends StatelessWidget {
  const _EcosystemScene({required this.active, required this.reduced});
  final bool active, reduced;

  @override
  Widget build(BuildContext context) => _AmbientStage(
    color: const Color(0xFFFFD9DE),
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 8,
          top: 48,
          width: 176,
          height: 190,
          child: _StaggeredProduct(
            active: active,
            reduced: reduced,
            duration: 420,
            offset: const Offset(-0.08, 0.08),
            child: Transform.rotate(
              angle: -0.06,
              child: ProductImage(
                path: productForId('macbook-air-13').assetPath,
                label: 'MacBook Air',
              ),
            ),
          ),
        ),
        Positioned(
          right: 12,
          top: 22,
          width: 152,
          height: 250,
          child: _StaggeredProduct(
            active: active,
            reduced: reduced,
            duration: 520,
            offset: const Offset(0.08, 0.1),
            child: ProductImage(
              path: productForId('iphone-17-pro').assetPath,
              label: 'iPhone 17 Pro',
            ),
          ),
        ),
        Positioned(
          left: 78,
          bottom: 12,
          width: 150,
          height: 150,
          child: _StaggeredProduct(
            active: active,
            reduced: reduced,
            duration: 610,
            offset: const Offset(0, 0.12),
            child: Transform.rotate(
              angle: 0.05,
              child: ProductImage(
                path: productForId('ipad-mini').assetPath,
                label: 'iPad mini',
              ),
            ),
          ),
        ),
        Positioned(
          right: 30,
          bottom: 22,
          width: 96,
          height: 96,
          child: _StaggeredProduct(
            active: active,
            reduced: reduced,
            duration: 690,
            offset: const Offset(0.08, 0.1),
            child: ProductImage(
              path: productForId('watch-series-11').assetPath,
              label: 'Apple Watch',
            ),
          ),
        ),
        Positioned(
          left: 18,
          bottom: 12,
          width: 86,
          height: 86,
          child: _StaggeredProduct(
            active: active,
            reduced: reduced,
            duration: 760,
            offset: const Offset(-0.08, 0.08),
            child: ProductImage(
              path: productForId('airpods-pro-3').assetPath,
              label: 'AirPods Pro',
            ),
          ),
        ),
      ],
    ),
  );
}

class _StaggeredProduct extends StatelessWidget {
  const _StaggeredProduct({
    required this.active,
    required this.reduced,
    required this.duration,
    required this.offset,
    required this.child,
  });

  final bool active, reduced;
  final int duration;
  final Offset offset;
  final Widget child;

  @override
  Widget build(BuildContext context) => AnimatedSlide(
    duration: Duration(milliseconds: reduced ? 0 : duration),
    curve: Curves.easeOutCubic,
    offset: active || reduced ? Offset.zero : offset,
    child: AnimatedOpacity(
      duration: Duration(milliseconds: reduced ? 80 : duration - 100),
      opacity: active
          ? 1
          : reduced
          ? 0.8
          : 0,
      child: child,
    ),
  );
}

class _CustomizationScene extends StatelessWidget {
  const _CustomizationScene({
    required this.index,
    required this.reduced,
    required this.onSelected,
  });
  final int index;
  final bool reduced;
  final ValueChanged<int> onSelected;
  @override
  Widget build(BuildContext context) {
    final product = productForId('iphone-17-pro');
    final variants = variantsFor(product);
    final active = variants[index];
    return AnimatedContainer(
      duration: Duration(milliseconds: reduced ? 60 : 280),
      decoration: BoxDecoration(
        color: Color.lerp(Colors.white, active.swatch, 0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: StoreColors.line),
      ),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                for (var i = 0; i < variants.length; i++)
                  if (i != index)
                    Transform.translate(
                      offset: Offset((i - index).sign * 42.0, 16),
                      child: Transform.rotate(
                        angle: reduced ? 0 : (i - index).sign * 0.075,
                        child: Opacity(
                          opacity: 0.28,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(48, 26, 48, 2),
                            child: ProductImage(
                              path: variants[i].imagePath,
                              label:
                                  '${product.name} ${variants[i].displayName}',
                            ),
                          ),
                        ),
                      ),
                    ),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: reduced ? 80 : 300),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: reduced
                        ? child
                        : ScaleTransition(
                            scale: Tween<double>(
                              begin: 0.97,
                              end: 1,
                            ).animate(animation),
                            child: child,
                          ),
                  ),
                  child: Padding(
                    key: ValueKey(active.id),
                    padding: const EdgeInsets.fromLTRB(40, 12, 40, 0),
                    child: ProductImage(
                      path: active.imagePath,
                      label: '${product.name} ${active.displayName}',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 14),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 56,
                      child: Text(
                        'Finish',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          for (var i = 0; i < variants.length; i++)
                            Semantics(
                              button: true,
                              selected: i == index,
                              label: variants[i].displayName,
                              child: InkWell(
                                key: Key('onboarding_finish_$i'),
                                onTap: () => onSelected(i),
                                customBorder: const CircleBorder(),
                                child: AnimatedContainer(
                                  duration: Duration(
                                    milliseconds: reduced ? 0 : 170,
                                  ),
                                  width: i == index ? 38 : 32,
                                  height: i == index ? 38 : 32,
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                      color: i == index
                                          ? StoreColors.red
                                          : StoreColors.line,
                                      width: i == index ? 2 : 1,
                                    ),
                                  ),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: variants[i].swatch,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    SizedBox(
                      width: 56,
                      child: Text(
                        'Storage',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(child: _OptionPreview(label: '128 GB')),
                          SizedBox(width: 6),
                          Expanded(
                            child: _OptionPreview(
                              label: '256 GB',
                              selected: true,
                            ),
                          ),
                          SizedBox(width: 6),
                          Expanded(child: _OptionPreview(label: '512 GB')),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionPreview extends StatelessWidget {
  const _OptionPreview({required this.label, this.selected = false});
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) => Container(
    height: 34,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.86),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: selected ? StoreColors.red : StoreColors.line),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 10,
        fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
      ),
    ),
  );
}

class _CommerceScene extends StatelessWidget {
  const _CommerceScene({required this.active, required this.reduced});
  final bool active, reduced;

  @override
  Widget build(BuildContext context) {
    return _AmbientStage(
      color: const Color(0xFFDCE9FF),
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 18,
              top: 18,
              right: 76,
              bottom: 18,
              child: Transform.rotate(
                angle: reduced ? 0 : -0.025,
                child: const _CartPreviewPhone(),
              ),
            ),
            const Positioned(
              right: 18,
              top: 30,
              child: _FloatingAction(
                color: StoreColors.softRed,
                icon: Icons.favorite_rounded,
                iconColor: StoreColors.red,
              ),
            ),
            const Positioned(
              right: 12,
              top: 130,
              child: _FloatingAction(
                color: StoreColors.red,
                icon: Icons.shopping_bag_rounded,
                iconColor: Colors.white,
                badge: '3',
              ),
            ),
            const Positioned(
              right: 18,
              bottom: 26,
              child: _FloatingAction(
                color: Colors.white,
                icon: Icons.check_rounded,
                iconColor: StoreColors.ink,
              ),
            ),
            if (active && !reduced)
              TweenAnimationBuilder<double>(
                key: const ValueKey('onboarding_bag_flight'),
                duration: const Duration(milliseconds: 620),
                curve: Curves.easeInOutCubic,
                tween: Tween(begin: 0, end: 1),
                builder: (context, value, child) {
                  final start = Offset(
                    constraints.maxWidth * 0.34,
                    constraints.maxHeight * 0.56,
                  );
                  final end = Offset(
                    constraints.maxWidth - 50,
                    constraints.maxHeight * 0.44,
                  );
                  final position = Offset.lerp(start, end, value)!;
                  final arc = -42 * 4 * value * (1 - value);
                  return Positioned(
                    left: position.dx - 18,
                    top: position.dy + arc - 18,
                    width: 36,
                    height: 36,
                    child: Opacity(
                      opacity: (1 - value * 0.35).clamp(0, 1),
                      child: Transform.scale(
                        scale: 1 - value * 0.28,
                        child: child,
                      ),
                    ),
                  );
                },
                child: ProductImage(
                  path: productForId('iphone-17-pro').assetPath,
                  label: 'iPhone moving to bag',
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CartPreviewPhone extends StatelessWidget {
  const _CartPreviewPhone();

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: const Color(0xFF111216),
      borderRadius: BorderRadius.circular(34),
      boxShadow: const [
        BoxShadow(
          color: Color(0x26000000),
          blurRadius: 24,
          offset: Offset(0, 9),
        ),
      ],
    ),
    padding: const EdgeInsets.all(5),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(29),
      child: ColoredBox(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 9, 12, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: StoreColors.ink,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Row(
                children: [
                  Expanded(
                    child: Text(
                      'Your Bag',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 9,
                    backgroundColor: StoreColors.red,
                    child: Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              _CartPreviewLine(
                path: productForId('iphone-17-pro').assetPath,
                name: 'iPhone 17 Pro',
                detail: '256 GB · Crimson Red',
              ),
              const Divider(height: 4),
              _CartPreviewLine(
                path: productForId('airpods-pro-3').assetPath,
                name: 'AirPods Pro',
                detail: 'White',
              ),
              const Spacer(),
              const Row(
                children: [
                  Expanded(
                    child: Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    r'$1,248',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: StoreColors.red,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Text(
                  'Checkout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
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

class _CartPreviewLine extends StatelessWidget {
  const _CartPreviewLine({
    required this.path,
    required this.name,
    required this.detail,
  });
  final String path, name, detail;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 42,
    child: Row(
      children: [
        SizedBox(
          width: 36,
          height: 38,
          child: ProductImage(path: path, label: name),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                detail,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 8, color: StoreColors.muted),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _AmbientStage extends StatelessWidget {
  const _AmbientStage({required this.color, required this.child});
  final Color color;
  final Widget child;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      gradient: RadialGradient(
        center: const Alignment(0.2, -0.2),
        radius: 1.1,
        colors: [color, Colors.white],
      ),
      border: Border.all(color: StoreColors.line),
    ),
    child: child,
  );
}

class _FloatingAction extends StatelessWidget {
  const _FloatingAction({
    required this.color,
    required this.icon,
    required this.iconColor,
    this.badge,
  });
  final Color color, iconColor;
  final IconData icon;
  final String? badge;
  @override
  Widget build(BuildContext context) => Stack(
    clipBehavior: Clip.none,
    children: [
      Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(color: Color(0x18000000), blurRadius: 16),
          ],
        ),
        child: Icon(icon, color: iconColor),
      ),
      if (badge != null)
        Positioned(
          right: -3,
          top: -3,
          child: CircleAvatar(
            radius: 10,
            backgroundColor: StoreColors.red,
            child: Text(
              badge!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
    ],
  );
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.index, required this.reduced});
  final int index;
  final bool reduced;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      for (var i = 0; i < 3; i++)
        AnimatedContainer(
          duration: Duration(milliseconds: reduced ? 0 : 190),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: i == index ? 28 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: i == index ? StoreColors.red : StoreColors.line,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
    ],
  );
}
