import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final reducedMotionControllerProvider =
    NotifierProvider<ReducedMotionController, ReducedMotionState>(
      ReducedMotionController.new,
    );
final reducedMotionProvider = Provider<bool>(
  (ref) => ref.watch(reducedMotionControllerProvider).effective,
);

class ReducedMotionState {
  const ReducedMotionState({this.override, this.platformPreference = false});
  final bool? override;
  final bool platformPreference;
  bool get effective => override ?? platformPreference;
  ReducedMotionState copyWith({
    bool? override,
    bool clearOverride = false,
    bool? platformPreference,
  }) => ReducedMotionState(
    override: clearOverride ? null : (override ?? this.override),
    platformPreference: platformPreference ?? this.platformPreference,
  );
}

class ReducedMotionController extends Notifier<ReducedMotionState> {
  @override
  ReducedMotionState build() => ReducedMotionState(
    platformPreference:
        PlatformDispatcher.instance.accessibilityFeatures.disableAnimations,
  );
  void setPlatformPreference(bool value) =>
      state = state.copyWith(platformPreference: value);
  void setOverride(bool? value) => state = value == null
      ? state.copyWith(clearOverride: true)
      : state.copyWith(override: value);
  void toggleDevelopmentOverride() => setOverride(!state.effective);
}
