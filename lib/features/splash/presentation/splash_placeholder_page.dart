import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/design_system/app_scaffold.dart';
import '../../../app/design_system/app_text_button.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_typography.dart';

class SplashPlaceholderPage extends StatelessWidget {
  const SplashPlaceholderPage({super.key});
  @override
  Widget build(BuildContext context) => AppScaffold(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        const Text('AETHER', style: AppTypography.label),
        const SizedBox(height: 16),
        const Text('A quiet beginning.', style: AppTypography.display),
        const SizedBox(height: 16),
        const Text(
          'Splash placeholder · no timing implemented',
          style: AppTypography.body,
        ),
        const Spacer(),
        AppTextButton(
          label: 'Enter',
          onPressed: () => context.goNamed(AppRoutes.home),
        ),
      ],
    ),
  );
}
