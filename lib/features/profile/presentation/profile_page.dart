import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/store_theme_v2.dart';
import '../../../core/accessibility/reduced_motion_controller.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reduced = ref.watch(reducedMotionProvider);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            Text('Profile', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 22),
            const Card(
              color: StoreColors.softRed,
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person_rounded,
                        color: StoreColors.red,
                        size: 36,
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Portfolio Guest',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text('Demo profile · local session'),
                        ],
                      ),
                    ),
                    Icon(Icons.verified_outlined, color: StoreColors.red),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _ProfileRow(
              icon: Icons.receipt_long_outlined,
              title: 'Orders',
              subtitle: 'Order history and delivery status',
              onTap: () => _showProfilePanel(
                context,
                icon: Icons.receipt_long_outlined,
                title: 'Orders',
                message:
                    'Completed preview orders will appear here with delivery updates.',
              ),
            ),
            _ProfileRow(
              icon: Icons.location_on_outlined,
              title: 'Addresses',
              subtitle: 'Delivery addresses for this session',
              onTap: () => _showProfilePanel(
                context,
                icon: Icons.location_on_outlined,
                title: 'Addresses',
                message:
                    'Add an address during preview checkout to complete the delivery flow.',
              ),
            ),
            _ProfileRow(
              icon: Icons.tune_rounded,
              title: 'Preferences',
              subtitle: 'Shopping, display, and accessibility',
              onTap: () => _showProfilePanel(
                context,
                icon: Icons.tune_rounded,
                title: 'Preferences',
                message:
                    'Accessibility preferences apply immediately to this local session.',
              ),
            ),
            Card(
              child: SwitchListTile(
                secondary: const Icon(Icons.motion_photos_off_outlined),
                title: const Text('Reduced Motion'),
                subtitle: const Text('Use short fades and immediate updates'),
                value: reduced,
                onChanged: (value) => ref
                    .read(reducedMotionControllerProvider.notifier)
                    .setOverride(value),
              ),
            ),
            const SizedBox(height: 10),
            _ProfileRow(
              icon: Icons.slideshow_rounded,
              title: 'View onboarding',
              subtitle: 'Replay the product experience introduction',
              onTap: () => context.pushNamed(
                AppRoutes.onboarding,
                queryParameters: const {'preview': 'true'},
              ),
            ),
            const SizedBox(height: 20),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About AppleStore Concept',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Unofficial educational and portfolio concept. Not affiliated with or endorsed by Apple Inc. Product names are used descriptively; product renders are original concept assets.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    child: ListTile(
      minTileHeight: 68,
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    ),
  );
}

void _showProfilePanel(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String message,
}) => showModalBottomSheet<void>(
  context: context,
  showDragHandle: true,
  builder: (context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: StoreColors.softRed,
            child: Icon(icon, color: StoreColors.red),
          ),
          const SizedBox(height: 14),
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    ),
  ),
);
