import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/design_system/app_scaffold.dart';
import '../../../app/design_system/app_text_button.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_typography.dart';

class HomePlaceholderPage extends StatelessWidget {
  const HomePlaceholderPage({super.key});
  @override
  Widget build(BuildContext context) => AppScaffold(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        const Text('HOME / PLACEHOLDER', style: AppTypography.label),
        const SizedBox(height: 12),
        const Text(
          'The product story begins here.',
          style: AppTypography.headline,
        ),
        const SizedBox(height: 12),
        const Text('Route foundation only.', style: AppTypography.body),
        const Spacer(),
        AppTextButton(
          label: 'Open Catalog',
          onPressed: () => context.goNamed(AppRoutes.catalog),
        ),
        AppTextButton(
          label: 'Open Featured Product',
          onPressed: () => context.pushNamed(
            AppRoutes.product,
            pathParameters: {'productId': 'sample-phone'},
          ),
        ),
        AppTextButton(
          label: 'Open Cart',
          onPressed: () => context.goNamed(AppRoutes.cart),
        ),
      ],
    ),
  );
}
