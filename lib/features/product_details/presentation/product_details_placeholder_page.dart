import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/design_system/app_scaffold.dart';
import '../../../app/design_system/app_text_button.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_typography.dart';
import '../../home/presentation/home_products.dart';
import '../../home/presentation/production_phone_render.dart';

class ProductDetailsPlaceholderPage extends StatelessWidget {
  const ProductDetailsPlaceholderPage({super.key, required this.productId});
  final String productId;
  @override
  Widget build(BuildContext context) => AppScaffold(
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PRODUCT / PLACEHOLDER', style: AppTypography.label),
          const SizedBox(height: 20),
          Hero(
            tag: productForId(productId).heroTag,
            child: SizedBox(
              width: 170,
              child: ProductionPhoneRender(product: productForId(productId)),
            ),
          ),
          const SizedBox(height: 20),
          Text(productId, style: AppTypography.headline),
          const SizedBox(height: 12),
          const Text(
            'Product details route foundation.',
            style: AppTypography.body,
          ),
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
    ),
  );
}
