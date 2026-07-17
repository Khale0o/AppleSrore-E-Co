import 'package:applestore/app/app.dart';
import 'package:applestore/app/router/app_router.dart';
import 'package:applestore/core/accessibility/reduced_motion_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpApp(
  WidgetTester tester, {
  ProviderContainer? container,
}) async {
  appRouter.go('/');
  await tester.pumpWidget(
    container == null
        ? const ProviderScope(child: AppleStoreApp())
        : UncontrolledProviderScope(
            container: container,
            child: const AppleStoreApp(),
          ),
  );
  await tester.pumpAndSettle();
}

Future<void> enterHome(WidgetTester tester) async {
  await tester.tap(find.textContaining('Enter'));
  await tester.pumpAndSettle();
}

Future<void> openSampleProduct(WidgetTester tester) async {
  await enterHome(tester);
  await tester.tap(find.textContaining('Open Featured Product'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('app starts on the Splash placeholder', (tester) async {
    await pumpApp(tester);
    expect(find.text('A quiet beginning.'), findsOneWidget);
  });

  testWidgets('Splash navigation reaches Home', (tester) async {
    await pumpApp(tester);
    await enterHome(tester);
    expect(find.text('The product story begins here.'), findsOneWidget);
  });

  testWidgets('Home opens Catalog', (tester) async {
    await pumpApp(tester);
    await enterHome(tester);
    await tester.tap(find.textContaining('Open Catalog'));
    await tester.pumpAndSettle();
    expect(find.text('A focused collection awaits.'), findsOneWidget);
  });

  testWidgets('Home opens the sample Product Details route', (tester) async {
    await pumpApp(tester);
    await openSampleProduct(tester);
    expect(find.text('PRODUCT / PLACEHOLDER'), findsOneWidget);
  });

  testWidgets('Product Details displays its supplied productId', (
    tester,
  ) async {
    await pumpApp(tester);
    await openSampleProduct(tester);
    expect(find.text('sample-phone'), findsOneWidget);
  });

  testWidgets('Product Details opens Configuration with the same productId', (
    tester,
  ) async {
    await pumpApp(tester);
    await openSampleProduct(tester);
    await tester.tap(find.textContaining('Configure'));
    await tester.pumpAndSettle();
    expect(find.text('CONFIGURATION / PLACEHOLDER'), findsOneWidget);
    expect(find.text('sample-phone'), findsOneWidget);
  });

  testWidgets('Cart route opens successfully', (tester) async {
    await pumpApp(tester);
    await enterHome(tester);
    await tester.tap(find.textContaining('Open Cart'));
    await tester.pumpAndSettle();
    expect(
      find.text('Your selected products will appear here.'),
      findsOneWidget,
    );
  });

  testWidgets('unknown route displays the themed error page', (tester) async {
    await pumpApp(tester);
    appRouter.go('/unknown');
    await tester.pumpAndSettle();
    expect(find.text('ROUTE UNAVAILABLE'), findsOneWidget);
    expect(find.text('That scene is not available.'), findsOneWidget);
  });

  test('Reduced Motion override changes the effective provider value', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(container.read(reducedMotionProvider), isFalse);
    container.read(reducedMotionControllerProvider.notifier).setOverride(true);
    expect(container.read(reducedMotionProvider), isTrue);
    container.read(reducedMotionControllerProvider.notifier).setOverride(null);
    expect(container.read(reducedMotionProvider), isFalse);
  });

  testWidgets('navigation remains functional while Reduced Motion is enabled', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(reducedMotionControllerProvider.notifier).setOverride(true);
    await pumpApp(tester, container: container);
    await enterHome(tester);
    await tester.tap(find.textContaining('Open Featured Product'));
    await tester.pumpAndSettle();
    expect(find.text('sample-phone'), findsOneWidget);
  });
}
