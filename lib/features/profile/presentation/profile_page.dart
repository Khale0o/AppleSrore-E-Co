import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            const Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: StoreColors.softRed,
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
                      Text('UI-only profile · no account required'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const _ProfileRow(
              icon: Icons.receipt_long_outlined,
              title: 'Orders',
              subtitle: 'Preview order history UI',
            ),
            const _ProfileRow(
              icon: Icons.location_on_outlined,
              title: 'Addresses',
              subtitle: 'Manage delivery address UI',
            ),
            const _ProfileRow(
              icon: Icons.tune_rounded,
              title: 'Preferences',
              subtitle: 'Store and display preferences',
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
                      'Unofficial educational and portfolio concept. Not affiliated with or endorsed by Apple Inc. Product names and imagery belong to their respective owners.',
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
  });
  final IconData icon;
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    child: ListTile(
      minTileHeight: 68,
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () {},
    ),
  );
}
