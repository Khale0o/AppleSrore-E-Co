import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/accessibility/reduced_motion_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';

class AppTextButton extends ConsumerStatefulWidget {
  const AppTextButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  ConsumerState<AppTextButton> createState() => _AppTextButtonState();
}

class _AppTextButtonState extends ConsumerState<AppTextButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final reduced = ref.watch(reducedMotionProvider);
    return Semantics(
      button: true,
      child: GestureDetector(
        onTap: widget.onPressed,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          duration: reduced ? AppMotion.instant : AppMotion.fast,
          scale: _pressed && !reduced ? .98 : 1,
          child: Container(
            constraints: const BoxConstraints(minHeight: 44),
            alignment: Alignment.centerLeft,
            child: Text(
              '${widget.label}  →',
              style: const TextStyle(
                color: AppColors.coolAccent,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: .4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
