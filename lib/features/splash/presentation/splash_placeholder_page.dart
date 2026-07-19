import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/accessibility/reduced_motion_controller.dart';
import '../../../shared/widgets/product_image.dart';
import '../../home/presentation/home_products.dart';

class SplashPlaceholderPage extends ConsumerStatefulWidget {
  const SplashPlaceholderPage({super.key});

  @override
  ConsumerState<SplashPlaceholderPage> createState() => _SplashState();
}

class _SplashState extends ConsumerState<SplashPlaceholderPage>
    with SingleTickerProviderStateMixin {
  static bool _hasPlayed = false;
  late final AnimationController _controller;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _begin());
  }

  void _begin() {
    if (!mounted) return;
    final reduced = ref.read(reducedMotionProvider);
    final duration = reduced || _hasPlayed
        ? const Duration(milliseconds: 120)
        : const Duration(milliseconds: 1050);
    if (!reduced && !_hasPlayed) _controller.forward();
    _hasPlayed = true;
    _navigationTimer = Timer(duration, () {
      if (mounted) context.goNamed(AppRoutes.home);
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = ref.watch(reducedMotionProvider);
    final product = homeProducts.first;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 240,
              height: 300,
              child: reduced
                  ? ProductImage(
                      path: product.assetPath,
                      label: product.name,
                      heroTag: product.heroTag,
                    )
                  : AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        final reveal = CurvedAnimation(
                          parent: _controller,
                          curve: const Interval(
                            0.2,
                            1,
                            curve: Curves.easeOutCubic,
                          ),
                        ).value;
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Opacity(
                              opacity:
                                  (1 -
                                          (_controller.value - 0.65).clamp(
                                                0,
                                                0.35,
                                              ) /
                                              0.35)
                                      .clamp(0, 1),
                              child: Transform.scale(
                                scale: 0.82 + (_controller.value * 0.22),
                                child: Container(
                                  width: 210,
                                  height: 210,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFE32636),
                                      width: 1.4,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x33E32636),
                                        blurRadius: 24,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: reveal,
                              child: Transform.scale(
                                scale: 0.9 + reveal * 0.1,
                                child: ProductImage(
                                  path: product.assetPath,
                                  label: product.name,
                                  heroTag: product.heroTag,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
            const SizedBox(height: 24),
            const Text(
              'AppleStore Concept',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Unofficial portfolio experience',
              style: TextStyle(color: Color(0xFF77777F)),
            ),
          ],
        ),
      ),
    );
  }
}
