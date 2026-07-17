import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/design_system/app_scaffold.dart';
import '../../../app/design_system/app_text_button.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_typography.dart';

class CatalogPlaceholderPage extends StatelessWidget {
  const CatalogPlaceholderPage({super.key});
  @override
  Widget build(BuildContext context) => AppScaffold(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        const Text('CATALOG / PLACEHOLDER', style: AppTypography.label),
        const SizedBox(height: 12),
        const Text(
          'A focused collection awaits.',
          style: AppTypography.headline,
        ),
        const Spacer(),
        AppTextButton(
          label: 'Open sample-phone',
          onPressed: () => context.pushNamed(
            AppRoutes.product,
            pathParameters: {'productId': 'sample-phone'},
          ),
        ),
        AppTextButton(
          label: 'Back Home',
          onPressed: () => context.goNamed(AppRoutes.home),
        ),
      ],
    ),
  );
}
