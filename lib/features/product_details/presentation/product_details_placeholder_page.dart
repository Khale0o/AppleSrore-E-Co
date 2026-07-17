import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/design_system/app_scaffold.dart';
import '../../../app/design_system/app_text_button.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_typography.dart';

class ProductDetailsPlaceholderPage extends StatelessWidget {
  const ProductDetailsPlaceholderPage({super.key, required this.productId});
  final String productId;
  @override
  Widget build(BuildContext context) => AppScaffold(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        const Text('PRODUCT / PLACEHOLDER', style: AppTypography.label),
        const SizedBox(height: 12),
        Text(productId, style: AppTypography.headline),
        const SizedBox(height: 12),
        const Text(
          'Product details route foundation.',
          style: AppTypography.body,
        ),
        const Spacer(),
        AppTextButton(
          label: 'Configure',
          onPressed: () => context.pushNamed(
            AppRoutes.configure,
            pathParameters: {'productId': productId},
          ),
        ),
        AppTextButton(label: 'Back', onPressed: () => context.pop()),
      ],
    ),
  );
}
