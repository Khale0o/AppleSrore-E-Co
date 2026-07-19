import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/accessibility/reduced_motion_controller.dart';
import '../../features/cart/presentation/cart_placeholder_page.dart';
import '../../features/catalog/presentation/catalog_placeholder_page.dart';
import '../../features/checkout/presentation/checkout_page.dart';
import '../../features/home/presentation/home_placeholder_page.dart';
import '../../features/onboarding/presentation/onboarding_page.dart';
import '../../features/product_configuration/presentation/product_configuration_placeholder_page.dart';
import '../../features/product_details/presentation/product_details_placeholder_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/saved/presentation/saved_page.dart';
import '../../features/shell/presentation/store_shell.dart';
import '../../features/splash/presentation/splash_placeholder_page.dart';
import '../design_system/app_scaffold.dart';
import '../design_system/app_text_button.dart';
import '../theme/app_typography.dart';
import 'app_routes.dart';
import 'route_transitions.dart';

bool _reduced(BuildContext context) =>
    ProviderScope.containerOf(context).read(reducedMotionProvider);
CustomTransitionPage<void> _page(
  GoRouterState state,
  BuildContext context,
  Widget child,
) => appTransitionPage(
  key: state.pageKey,
  child: child,
  reducedMotion: _reduced(context),
);
final appRouter = GoRouter(
  initialLocation: AppRoutes.splashPath,
  routes: [
    GoRoute(
      name: AppRoutes.splash,
      path: AppRoutes.splashPath,
      pageBuilder: (c, s) => _page(s, c, const SplashPlaceholderPage()),
    ),
    GoRoute(
      name: AppRoutes.onboarding,
      path: AppRoutes.onboardingPath,
      pageBuilder: (c, s) => _page(
        s,
        c,
        OnboardingPage(preview: s.uri.queryParameters['preview'] == 'true'),
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          StoreShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: AppRoutes.home,
              path: AppRoutes.homePath,
              pageBuilder: (c, s) => _page(s, c, const HomePlaceholderPage()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: AppRoutes.catalog,
              path: AppRoutes.catalogPath,
              pageBuilder: (c, s) =>
                  _page(s, c, const CatalogPlaceholderPage()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: AppRoutes.saved,
              path: AppRoutes.savedPath,
              pageBuilder: (c, s) => _page(s, c, const SavedPage()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: AppRoutes.cart,
              path: AppRoutes.cartPath,
              pageBuilder: (c, s) => _page(s, c, const CartPlaceholderPage()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: AppRoutes.profile,
              path: AppRoutes.profilePath,
              pageBuilder: (c, s) => _page(s, c, const ProfilePage()),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      name: AppRoutes.product,
      path: AppRoutes.productPath,
      pageBuilder: (c, s) => _page(
        s,
        c,
        ProductDetailsPlaceholderPage(
          productId: s.pathParameters['productId']!,
        ),
      ),
      routes: [
        GoRoute(
          name: AppRoutes.configure,
          path: 'configure',
          pageBuilder: (c, s) => _page(
            s,
            c,
            ProductConfigurationPlaceholderPage(
              productId: s.pathParameters['productId']!,
            ),
          ),
        ),
      ],
    ),
    GoRoute(
      name: AppRoutes.checkout,
      path: AppRoutes.checkoutPath,
      pageBuilder: (c, s) => _page(s, c, const CheckoutPage()),
    ),
  ],
  errorPageBuilder: (c, s) =>
      _page(s, c, _ErrorPage(onHome: () => c.goNamed(AppRoutes.home))),
);

class _ErrorPage extends StatelessWidget {
  const _ErrorPage({required this.onHome});
  final VoidCallback onHome;
  @override
  Widget build(BuildContext context) => AppScaffold(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        const Text('ROUTE UNAVAILABLE', style: AppTypography.label),
        const SizedBox(height: 12),
        const Text(
          'That scene is not available.',
          style: AppTypography.headline,
        ),
        const Spacer(),
        AppTextButton(label: 'Back Home', onPressed: onHome),
      ],
    ),
  );
}
