import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.child, this.padding = true});
  final Widget child;
  final bool padding;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Container(
        color: AppColors.background,
        padding: padding
            ? const EdgeInsets.all(AppSpacing.lg)
            : EdgeInsets.zero,
        child: child,
      ),
    ),
  );
}
