import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/design_system/app_scaffold.dart';
import '../../../app/design_system/app_text_button.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_typography.dart';

class ProductConfigurationPlaceholderPage extends StatelessWidget {
  const ProductConfigurationPlaceholderPage({
    super.key,
    required this.productId,
  });
  final String productId;
  @override
  Widget build(BuildContext context) => AppScaffold(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        const Text('CONFIGURATION / PLACEHOLDER', style: AppTypography.label),
        const SizedBox(height: 12),
        Text(productId, style: AppTypography.headline),
        const Spacer(),
        AppTextButton(
          label: 'Open Cart',
          onPressed: () => context.goNamed(AppRoutes.cart),
        ),
        AppTextButton(label: 'Back', onPressed: () => context.pop()),
      ],
    ),
  );
}
