import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_motion.dart';

CustomTransitionPage<void> appTransitionPage({
  required LocalKey key,
  required Widget child,
  required bool reducedMotion,
}) => CustomTransitionPage<void>(
  key: key,
  child: child,
  transitionDuration: reducedMotion ? AppMotion.instant : AppMotion.standard,
  reverseTransitionDuration: AppMotion.fast,
  transitionsBuilder: (context, animation, secondary, child) {
    final fade = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
    return FadeTransition(
      opacity: fade,
      child: reducedMotion
          ? child
          : SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, .015),
                end: Offset.zero,
              ).animate(fade),
              child: child,
            ),
    );
  },
);
