import 'package:applestore/app/app.dart';
import 'package:applestore/app/router/app_router.dart';
import 'package:applestore/features/home/presentation/production_phone_render.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpHome(WidgetTester tester) async {
  appRouter.go('/');
  await tester.pumpWidget(const ProviderScope(child: AppleStoreApp()));
  await tester.pumpAndSettle();
  await tester.tap(find.textContaining('Enter'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Home renders the first fictional product', (tester) async {
    await pumpHome(tester);
    expect(find.text('Aether Pro'), findsOneWidget);
  });

  testWidgets('indicator selects another product and updates its text', (
    tester,
  ) async {
    await pumpHome(tester);
    await tester.tap(find.byKey(const Key('indicator_1')));
    await tester.pumpAndSettle();
    expect(find.text('Aether Air'), findsOneWidget);
    expect(find.text('FROST SILVER'), findsOneWidget);
  });

  testWidgets('Reduced Motion toggle changes state', (tester) async {
    await pumpHome(tester);
    await tester.tap(find.byKey(const Key('reduced_motion_toggle')));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<Switch>(find.byKey(const Key('reduced_motion_toggle')))
          .value,
      isTrue,
    );
  });

  testWidgets('selected product opens Details with the correct productId', (
    tester,
  ) async {
    await pumpHome(tester);
    await tester.tap(find.byType(ProductionPhoneRender).first);
    await tester.pumpAndSettle();
    expect(find.text('aether-pro'), findsOneWidget);
  });

  testWidgets('Explore opens the selected product Details route', (
    tester,
  ) async {
    await pumpHome(tester);
    await tester.tap(find.byKey(const Key('indicator_2')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('explore_action')));
    await tester.pumpAndSettle();
    expect(find.text('aether-mini'), findsOneWidget);
  });

  testWidgets('Back returns Home with selected product preserved', (
    tester,
  ) async {
    await pumpHome(tester);
    await tester.tap(find.byKey(const Key('indicator_1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ProductionPhoneRender).first);
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Aether Air'), findsOneWidget);
  });
}
