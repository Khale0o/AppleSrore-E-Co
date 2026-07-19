import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/accessibility/reduced_motion_controller.dart';
import '../../../shared/widgets/product_image.dart';
import '../../home/presentation/home_products.dart';
import '../../onboarding/application/onboarding_store.dart';

class SplashPlaceholderPage extends ConsumerStatefulWidget {
  const SplashPlaceholderPage({super.key});

  @override
  ConsumerState<SplashPlaceholderPage> createState() => _SplashState();
}

class _SplashState extends ConsumerState<SplashPlaceholderPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _navigating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2300),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _begin());
  }

  Future<void> _begin() async {
    if (!mounted || _navigating) return;
    _navigating = true;
    final reduced = ref.read(reducedMotionProvider);
    final completion = ref
        .read(onboardingStoreProvider)
        .isComplete()
        .onError((error, stackTrace) => false);
    final completionWait = completion.then<void>((_) {});
    if (reduced) {
      await Future.wait<void>([
        completionWait,
        Future<void>.delayed(const Duration(milliseconds: 320)),
      ]);
    } else {
      await Future.wait<void>([
        completionWait,
        _controller.forward(),
        Future<void>.delayed(const Duration(milliseconds: 2550)),
      ]);
    }
    if (!mounted) return;
    final complete = await completion;
    if (!mounted) return;
    context.goNamed(complete ? AppRoutes.home : AppRoutes.onboarding);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = ref.watch(reducedMotionProvider);
    final phone = productForId('iphone-17-pro');
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = reduced ? 1.0 : _controller.value;
        final backgroundReveal = _interval(value, 0, 0.32);
        final identity = _interval(value, 0.05, 0.32);
        final ring = _interval(value, 0.08, 0.48);
        final phoneReveal = _interval(value, 0.18, 0.62);
        final finishReveal = _interval(value, 0.48, 0.75);
        final progress = _interval(value, 0.2, 0.88);
        final handoff = reduced ? 1.0 : _interval(value, 0.86, 1);
        final sceneOpacity = reduced ? 1.0 : 1 - _interval(value, 0.9, 1);
        final foreground = Color.lerp(
          Colors.white,
          const Color(0xFF111216),
          handoff,
        )!;

        return Scaffold(
          backgroundColor: Color.lerp(
            const Color(0xFF090A0D),
            const Color(0xFFFAFAFC),
            handoff,
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final phoneWidth = (constraints.maxWidth * 0.58).clamp(
                      190.0,
                      260.0,
                    );
                    final stageHeight = (constraints.maxHeight * 0.62).clamp(
                      320.0,
                      450.0,
                    );
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.lerp(
                                    const Color(0xFF181A1F),
                                    const Color(0xFFFAFAFC),
                                    handoff,
                                  )!,
                                  Color.lerp(
                                    const Color(0xFF07080B),
                                    const Color(0xFFF7F7F9),
                                    handoff,
                                  )!,
                                  Color.lerp(
                                    const Color(0xFF151216),
                                    const Color(0xFFFAFAFC),
                                    handoff,
                                  )!,
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: constraints.maxHeight * 0.075,
                          left: 24,
                          right: 24,
                          child: Opacity(
                            opacity: identity * sceneOpacity,
                            child: Transform.translate(
                              offset: Offset(
                                0,
                                reduced ? 0 : 10 * (1 - identity),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'AppleStore',
                                    style: TextStyle(
                                      color: foreground,
                                      fontSize: 31,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'C O N C E P T',
                                    style: TextStyle(
                                      color: foreground.withValues(alpha: 0.62),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: constraints.maxHeight * 0.17,
                          left: 0,
                          right: 0,
                          height: stageHeight,
                          child: Opacity(
                            opacity: sceneOpacity,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Opacity(
                                  opacity: backgroundReveal * (1 - handoff),
                                  child: Container(
                                    width: phoneWidth * 1.62,
                                    height: phoneWidth * 1.62,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          Color(0x66F12A3A),
                                          Color(0x30C70F24),
                                          Color(0x08000000),
                                          Colors.transparent,
                                        ],
                                        stops: [0, 0.42, 0.72, 1],
                                      ),
                                    ),
                                  ),
                                ),
                                Opacity(
                                  opacity: ring * (1 - handoff),
                                  child: Transform.scale(
                                    scale: reduced ? 1 : 0.82 + ring * 0.18,
                                    child: Container(
                                      width: phoneWidth * 1.3,
                                      height: phoneWidth * 1.3,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: 0.2,
                                          ),
                                          width: 1,
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x2EFF3144),
                                            blurRadius: 30,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                if (!reduced)
                                  Opacity(
                                    opacity:
                                        ring * (1 - phoneReveal) * sceneOpacity,
                                    child: Transform.translate(
                                      offset: Offset(
                                        -phoneWidth + phoneWidth * 2 * ring,
                                        0,
                                      ),
                                      child: Transform.rotate(
                                        angle: -0.2,
                                        child: Container(
                                          width: 46,
                                          height: stageHeight * 0.72,
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.transparent,
                                                Color(0x28FFFFFF),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                Opacity(
                                  opacity: phoneReveal,
                                  child: Transform.translate(
                                    offset: Offset(
                                      0,
                                      reduced
                                          ? 0
                                          : 48 * (1 - phoneReveal) -
                                                handoff * 10,
                                    ),
                                    child: Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.identity()
                                        ..setEntry(3, 2, 0.0012)
                                        ..rotateY(
                                          reduced
                                              ? 0
                                              : -0.13 * (1 - phoneReveal),
                                        )
                                        ..rotateZ(
                                          reduced
                                              ? 0
                                              : 0.035 * (1 - phoneReveal),
                                        ),
                                      child: Transform.scale(
                                        scale: reduced
                                            ? 1
                                            : 0.87 + phoneReveal * 0.13,
                                        child: SizedBox(
                                          width: phoneWidth,
                                          height: stageHeight * 0.9,
                                          child: ProductImage(
                                            path: phone.assetPath,
                                            label: '${phone.name} in red',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 5,
                                  child: Opacity(
                                    opacity: finishReveal * sceneOpacity,
                                    child: Transform.translate(
                                      offset: Offset(
                                        0,
                                        reduced ? 0 : 8 * (1 - finishReveal),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 7,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color.lerp(
                                            const Color(0xCC191B20),
                                            Colors.white,
                                            handoff,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            22,
                                          ),
                                          border: Border.all(
                                            color: Color.lerp(
                                              const Color(0x44FFFFFF),
                                              const Color(0xFFE1E1E5),
                                              handoff,
                                            )!,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const DecoratedBox(
                                              decoration: BoxDecoration(
                                                color: Color(0xFFE32636),
                                                shape: BoxShape.circle,
                                              ),
                                              child: SizedBox(
                                                width: 9,
                                                height: 9,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'CRIMSON RED',
                                              style: TextStyle(
                                                color: foreground,
                                                fontSize: 9,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 1.2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 34,
                          right: 34,
                          bottom: 20,
                          child: Opacity(
                            opacity: finishReveal * sceneOpacity,
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 3,
                                    backgroundColor: foreground.withValues(
                                      alpha: 0.14,
                                    ),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Color(0xFFE32636),
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Discover. Choose. Own.',
                                  style: TextStyle(
                                    color: foreground,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Unofficial concept · Not affiliated with Apple Inc.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: foreground.withValues(alpha: 0.48),
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double _interval(double value, double start, double end) => Curves
      .easeOutCubic
      .transform(((value - start) / (end - start)).clamp(0, 1));
}
