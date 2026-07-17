import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/design_system/app_scaffold.dart';
import '../../../app/design_system/app_text_button.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_typography.dart';

class CartPlaceholderPage extends StatelessWidget {
  const CartPlaceholderPage({super.key});
  @override
  Widget build(BuildContext context) => AppScaffold(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        const Text('BAG / PLACEHOLDER', style: AppTypography.label),
        const SizedBox(height: 12),
        const Text(
          'Your selected products will appear here.',
          style: AppTypography.headline,
        ),
        const Spacer(),
        AppTextButton(
          label: 'Back Home',
          onPressed: () => context.goNamed(AppRoutes.home),
        ),
      ],
    ),
  );
}
