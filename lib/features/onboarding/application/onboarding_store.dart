import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class OnboardingStore {
  Future<bool> isComplete();
  Future<void> complete();
}

class PreferencesOnboardingStore implements OnboardingStore {
  static const _key = 'onboarding_complete_v1';
  static bool _sessionComplete = false;

  @override
  Future<bool> isComplete() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      return preferences.getBool(_key) ?? _sessionComplete;
    } on MissingPluginException {
      return _sessionComplete;
    }
  }

  @override
  Future<void> complete() async {
    _sessionComplete = true;
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool(_key, true);
    } on MissingPluginException {
      // A native plugin added during an active debug session is unavailable
      // until a full app restart. Keep navigation functional for this session.
    }
  }
}

final onboardingStoreProvider = Provider<OnboardingStore>(
  (ref) => PreferencesOnboardingStore(),
);
