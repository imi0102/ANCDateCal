import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/storage_service.dart';
import 'rewarded_ad_provider.dart';

final adGateProvider = Provider<AdGate>((ref) {
  return AdGate(ref);
});

class AdGate {
  AdGate(this.ref);

  final Ref ref;

  final StorageService _storage = StorageService();

  bool _isProcessing = false;

  // ------------------------------------------------------------
  // RUN ACTION WITH AD GATE
  // ------------------------------------------------------------

  Future<void> run({
    required String adId,
    required Future<void> Function() action,
  }) async {
    // ----------------------------------------------------------
    // WEB
    // ----------------------------------------------------------

    if (kIsWeb) {
      debugPrint(
        'AdGate → WEB → FREE',
      );

      await action();

      return;
    }

    // ----------------------------------------------------------
    // PREVENT DOUBLE CLICK
    // ----------------------------------------------------------

    if (_isProcessing) {
      debugPrint(
        'AdGate → Already processing',
      );

      return;
    }

    _isProcessing = true;

    try {
      // --------------------------------------------------------
      // INCREMENT COUNTER
      // --------------------------------------------------------

      final count =
      await _storage.incrementRewardedUsage();

      debugPrint(
        'AdGate → Usage: $count',
      );

      // --------------------------------------------------------
      // AD PATTERN
      //
      // 1 → SHOW
      // 2 → FREE
      // 3 → FREE
      // 4 → FREE
      // 5 → SHOW
      // 6 → FREE
      // ...
      // --------------------------------------------------------

      final shouldShowAd =
          count % 4 == 1;

      if (shouldShowAd) {
        debugPrint(
          'AdGate → SHOW AD → $adId',
        );

        await ref
            .read(rewardedAdProvider.notifier)
            .show(
          adId: adId,
        );
      } else {
        debugPrint(
          'AdGate → FREE',
        );
      }

      // --------------------------------------------------------
      // ALWAYS CONTINUE ACTION
      //
      // Ad not loaded / failed / unavailable
      // → Action still executes.
      // --------------------------------------------------------

      await action();
    } finally {
      _isProcessing = false;
    }
  }

  // ------------------------------------------------------------
  // RESET COUNTER
  // ------------------------------------------------------------

  Future<void> resetForTesting() async {
    await _storage.resetRewardedUsage();
  }
}