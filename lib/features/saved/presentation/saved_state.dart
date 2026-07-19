import 'package:flutter_riverpod/flutter_riverpod.dart';

class SavedItem {
  const SavedItem({
    required this.productId,
    required this.variantId,
    required this.variantName,
    required this.imagePath,
    this.optionValueIds = const {},
    this.optionLabels = const {},
    this.price,
  });
  final String productId, variantId, variantName, imagePath;
  final Map<String, String> optionValueIds, optionLabels;
  final int? price;
  String get key {
    final options = optionValueIds.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return '$productId|$variantId|${options.map((e) => '${e.key}=${e.value}').join('|')}';
  }
}

class SavedController extends Notifier<List<SavedItem>> {
  @override
  List<SavedItem> build() => [];
  bool contains(String productId) =>
      state.any((item) => item.productId == productId);
  void toggle(SavedItem item) {
    final exists = state.any((value) => value.key == item.key);
    state = exists
        ? state.where((value) => value.key != item.key).toList()
        : [...state, item];
  }

  void remove(SavedItem item) =>
      state = state.where((value) => value.key != item.key).toList();
}

final savedProvider = NotifierProvider<SavedController, List<SavedItem>>(
  SavedController.new,
);
final savedCountProvider = Provider<int>(
  (ref) => ref.watch(savedProvider).length,
);
