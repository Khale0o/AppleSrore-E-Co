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
      backgroundColor: const Color(0xFF030405),
      body: Center(
        child: reduced
            ? Opacity(
                opacity: 0.85,
                child: ProductImage(
                  path: product.assetPath,
                  label: product.name,
                  heroTag: product.heroTag,
                ),
              )
            : AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final reveal = CurvedAnimation(
                    parent: _controller,
                    curve: const Interval(0.2, 1, curve: Curves.easeOutCubic),
                  ).value;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity:
                            (1 -
                                    (_controller.value - 0.65).clamp(0, 0.35) /
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
                                color: Colors.white.withValues(alpha: 0.7),
                                width: 1.2,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x558FCFFF),
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
                          child: SizedBox(
                            width: 180,
                            height: 260,
                            child: ProductImage(
                              path: product.assetPath,
                              label: product.name,
                              heroTag: product.heroTag,
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
  }
}
