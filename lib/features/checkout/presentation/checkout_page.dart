import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/store_theme_v2.dart';
import '../../../core/accessibility/reduced_motion_controller.dart';
import '../../../shared/widgets/product_image.dart';
import '../../../shared/widgets/store_ui_v2.dart';
import '../../cart/presentation/cart_state.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  static const _steps = ['Shipping', 'Delivery', 'Payment', 'Review'];
  int _step = 0;
  int _delivery = 0;
  int _payment = 0;
  bool _confirmed = false;

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(cartProvider);
    final subtotal = ref.watch(cartSubtotalProvider);
    final tax = (subtotal * 0.07).round();
    final reduced = ref.watch(reducedMotionProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.canPop()
              ? context.pop()
              : context.goNamed(AppRoutes.cart),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(_confirmed ? 'Order Confirmed' : 'Checkout'),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: _confirmed
                ? _Confirmation(reduced: reduced)
                : items.isEmpty
                ? _EmptyCheckout(
                    onExplore: () => context.goNamed(AppRoutes.catalog),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Preview checkout',
                                  style: TextStyle(
                                    color: StoreColors.red,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const Spacer(),
                                Text('${_step + 1} of ${_steps.length}'),
                              ],
                            ),
                            const SizedBox(height: 10),
                            LinearProgressIndicator(
                              value: (_step + 1) / _steps.length,
                              minHeight: 4,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _steps[_step],
                              key: const Key('checkout_step_title'),
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: reduced ? 60 : 240),
                          transitionBuilder: (child, animation) {
                            if (reduced) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            }
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.04, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: SingleChildScrollView(
                            key: ValueKey(_step),
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: _stepContent(items, subtotal, tax),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(color: StoreColors.line),
                          ),
                        ),
                        child: Row(
                          children: [
                            if (_step > 0) ...[
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => setState(() => _step--),
                                  child: const Text('Back'),
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                            Expanded(
                              flex: 2,
                              child: FilledButton(
                                key: const Key('checkout_continue'),
                                onPressed: _continue,
                                child: Text(
                                  _step == _steps.length - 1
                                      ? 'Place Demo Order'
                                      : 'Continue',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _stepContent(List<CartItem> items, int subtotal, int tax) =>
      switch (_step) {
        0 => const _ShippingStep(),
        1 => _ChoiceStep(
          options: const [
            (
              icon: Icons.local_shipping_outlined,
              title: 'Standard delivery',
              subtitle: '3–5 business days · Free',
            ),
            (
              icon: Icons.bolt_outlined,
              title: 'Express delivery',
              subtitle: 'Next business day · \$19',
            ),
          ],
          selected: _delivery,
          onSelected: (value) => setState(() => _delivery = value),
        ),
        2 => _ChoiceStep(
          options: const [
            (
              icon: Icons.credit_card_rounded,
              title: 'Card ending in 4242',
              subtitle: 'Demo Visa · Expires 12/30',
            ),
            (
              icon: Icons.account_balance_wallet_outlined,
              title: 'Digital wallet',
              subtitle: 'Fast simulated payment',
            ),
          ],
          selected: _payment,
          onSelected: (value) => setState(() => _payment = value),
        ),
        _ => _ReviewStep(
          items: items,
          subtotal: subtotal,
          tax: tax,
          delivery: _delivery == 0 ? 'Standard · Free' : 'Express · \$19',
          payment: _payment == 0 ? 'Card ending in 4242' : 'Digital wallet',
        ),
      };

  void _continue() {
    if (_step < _steps.length - 1) {
      setState(() => _step++);
      return;
    }
    ref.read(cartProvider.notifier).clear();
    setState(() => _confirmed = true);
  }
}

class _ShippingStep extends StatelessWidget {
  const _ShippingStep();
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Where should we deliver your order?',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 16),
      const Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(labelText: 'First name'),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(labelText: 'Last name'),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      const TextField(
        key: Key('shipping_address'),
        decoration: InputDecoration(labelText: 'Street address'),
      ),
      const SizedBox(height: 12),
      const TextField(decoration: InputDecoration(labelText: 'City')),
      const SizedBox(height: 12),
      const Row(
        children: [
          Expanded(
            child: TextField(decoration: InputDecoration(labelText: 'State')),
          ),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(labelText: 'Postal code'),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      const Text(
        'This address is used only for the current demo session.',
        style: TextStyle(color: StoreColors.muted),
      ),
    ],
  );
}

class _ChoiceStep extends StatelessWidget {
  const _ChoiceStep({
    required this.options,
    required this.selected,
    required this.onSelected,
  });
  final List<({IconData icon, String title, String subtitle})> options;
  final int selected;
  final ValueChanged<int> onSelected;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (var index = 0; index < options.length; index++)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => onSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: selected == index
                    ? StoreColors.softRed
                    : StoreColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected == index ? StoreColors.red : StoreColors.line,
                ),
              ),
              child: Row(
                children: [
                  Icon(options[index].icon),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          options[index].title,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        Text(options[index].subtitle),
                      ],
                    ),
                  ),
                  Icon(
                    selected == index
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    color: selected == index
                        ? StoreColors.red
                        : StoreColors.muted,
                  ),
                ],
              ),
            ),
          ),
        ),
    ],
  );
}

class _ReviewStep extends StatelessWidget {
  const _ReviewStep({
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.delivery,
    required this.payment,
  });
  final List<CartItem> items;
  final int subtotal, tax;
  final String delivery, payment;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (final item in items)
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: SizedBox(
            width: 56,
            height: 64,
            child: ProductImage(path: item.imagePath, label: item.name),
          ),
          title: Text(item.name),
          subtitle: Text('${item.optionSummary} · Qty ${item.quantity}'),
          trailing: Text(formatUsd(item.unitPrice * item.quantity)),
        ),
      const Divider(height: 28),
      _ReviewLine(label: 'Delivery', value: delivery),
      const SizedBox(height: 10),
      _ReviewLine(label: 'Payment', value: payment),
      const SizedBox(height: 10),
      _ReviewLine(label: 'Subtotal', value: formatUsd(subtotal)),
      const SizedBox(height: 10),
      _ReviewLine(label: 'Estimated tax', value: formatUsd(tax)),
      const Divider(height: 28),
      _ReviewLine(
        label: 'Order total',
        value: formatUsd(
          subtotal + tax + (delivery.startsWith('Express') ? 19 : 0),
        ),
        emphasized: true,
      ),
    ],
  );
}

class _ReviewLine extends StatelessWidget {
  const _ReviewLine({
    required this.label,
    required this.value,
    this.emphasized = false,
  });
  final String label, value;
  final bool emphasized;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          label,
          style: TextStyle(
            fontWeight: emphasized ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ),
      Text(
        value,
        style: TextStyle(
          fontWeight: emphasized ? FontWeight.w900 : FontWeight.w600,
          fontSize: emphasized ? 18 : 14,
        ),
      ),
    ],
  );
}

class _Confirmation extends StatelessWidget {
  const _Confirmation({required this.reduced});
  final bool reduced;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      children: [
        const Spacer(),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: reduced ? 1 : 0.7, end: 1),
          duration: Duration(milliseconds: reduced ? 60 : 420),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) => Opacity(
            opacity: value.clamp(0, 1),
            child: Transform.scale(scale: value, child: child),
          ),
          child: const CircleAvatar(
            radius: 46,
            backgroundColor: StoreColors.softRed,
            child: Icon(Icons.check_rounded, size: 50, color: StoreColors.red),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Your order is confirmed',
          key: const Key('checkout_confirmation'),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        const Text(
          'Demo order AS-2048 is ready. No payment was processed.',
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => context.goNamed(AppRoutes.home),
            child: const Text('Continue Shopping'),
          ),
        ),
      ],
    ),
  );
}

class _EmptyCheckout extends StatelessWidget {
  const _EmptyCheckout({required this.onExplore});
  final VoidCallback onExplore;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.shopping_bag_outlined, size: 56),
          const SizedBox(height: 14),
          const Text('Add a product before starting checkout.'),
          const SizedBox(height: 18),
          FilledButton(onPressed: onExplore, child: const Text('Explore')),
        ],
      ),
    ),
  );
}
