import 'package:applestore/spikes/carousel_hero/carousel_hero_spike.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpSpike(WidgetTester tester) async {
    await tester.pumpWidget(const CarouselHeroSpikeApp());
    await tester.pumpAndSettle();
  }

  testWidgets('initially selects the first product', (tester) async {
    await pumpSpike(tester);
    expect(find.text('Aether One'), findsOneWidget);
  });

  testWidgets('second indicator selects the second product and updates text', (
    tester,
  ) async {
    await pumpSpike(tester);
    await tester.tap(find.byKey(const Key('indicator_1')));
    await tester.pumpAndSettle();
    expect(find.text('Aether One Air'), findsOneWidget);
  });

  testWidgets('selected product opens its details scene', (tester) async {
    await pumpSpike(tester);
    await tester.tap(find.byKey(const Key('product_aether_one')));
    await tester.pumpAndSettle();
    expect(find.text('Precision shaped around light.'), findsOneWidget);
  });

  testWidgets(
    'details displays selected product and back returns to carousel selection',
    (tester) async {
      await pumpSpike(tester);
      await tester.tap(find.byKey(const Key('indicator_1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('product_aether_one_air')));
      await tester.pumpAndSettle();
      expect(find.text('Aether One Air'), findsOneWidget);
      await tester.tap(find.byKey(const Key('details_back')));
      await tester.pumpAndSettle();
      expect(find.text('Aether One Air'), findsOneWidget);
    },
  );

  testWidgets(
    'Reduced Motion changes state while navigation remains functional',
    (tester) async {
      await pumpSpike(tester);
      await tester.tap(find.byKey(const Key('reduced_motion_toggle')));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<Switch>(find.byKey(const Key('reduced_motion_toggle')))
            .value,
        isTrue,
      );
      await tester.tap(find.byKey(const Key('indicator_1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('product_aether_one_air')));
      await tester.pumpAndSettle();
      expect(find.text('Aether One Air'), findsOneWidget);
    },
  );
}
