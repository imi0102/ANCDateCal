import 'package:anc_date_calculator/core/services/remote_config_service.dart';
import 'package:anc_date_calculator/features/date_calculator/presentation/widgets/watch_ad_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/storage_service.dart';
import '../services/remote_config_service.dart';
import '../utils/ad_gate_utils.dart';
import '../utils/trial_utils.dart';
import 'rewarded_ad_provider.dart';

final adGateProvider = Provider<AdGate>((ref) {
  return AdGate(ref);
});

class AdGate {
  AdGate(this.ref);

  final Ref ref;

  final StorageService _storage = StorageService();

  bool _isProcessing = false;

  // ===========================================================================
  // MAIN AD GATE
  // ===========================================================================

  Future<void> run({
    required String adId,
    required Future<void> Function() action,
  }) async {
    // =========================================================================
    // WEB
    // =========================================================================

    if (kIsWeb) {
      debugPrint(
        'AdGate → WEB → FREE',
      );

      await action();
      return;
    }

    // =========================================================================
    // REWARDED ADS REMOTELY DISABLED
    // =========================================================================
    //
    // IMPORTANT:
    //
    // If Firebase Remote Config disables rewarded ads,
    // do not:
    //
    // - load ad
    // - show WatchAdDialog
    // - show rewarded ad
    // - consume daily rewarded usage
    //
    // Simply allow the user to continue.
    // =========================================================================

    final remoteConfig =
        RemoteConfigService.instance;

    if (!remoteConfig.enableRewardedAds) {
      debugPrint(
        'AdGate → Rewarded Ads DISABLED by Remote Config → FREE',
      );

      await action();
      return;
    }

    // =========================================================================
    // PREVENT DOUBLE ACTION
    // =========================================================================

    if (_isProcessing) {
      debugPrint(
        'AdGate → Already processing',
      );

      return;
    }

    _isProcessing = true;

    try {
      // =======================================================================
      // FIRST INSTALL
      // =======================================================================

      final firstInstallDate =
      await _storage.getFirstInstallDate();

      if (firstInstallDate == null) {
        await _storage.saveFirstInstallDate(
          DateTime.now(),
        );

        debugPrint(
          'AdGate → FIRST INSTALL → 5 DAYS FREE',
        );

        await action();
        return;
      }

      // =======================================================================
      // TRIAL
      // =======================================================================

      final isTrialActive =
      TrialUtils.isTrialActive(
        firstInstallDate,
      );

      if (isTrialActive) {
        final remaining =
        TrialUtils.getRemainingTime(
          firstInstallDate,
        );

        debugPrint(
          'AdGate → FREE TRIAL ACTIVE → '
              '${remaining.inDays}d '
              '${remaining.inHours % 24}h remaining',
        );

        await action();
        return;
      }

      debugPrint(
        'AdGate → TRIAL EXPIRED',
      );

      // =======================================================================
      // DAILY USAGE
      // =======================================================================

      final currentUsage =
      await _storage.getRewardedUsage();

      debugPrint(
        'AdGate → Current Usage Today: '
            '$currentUsage',
      );

      final nextUsage =
          currentUsage + 1;

      final shouldShowAd =
      AdGateUtils.shouldShowAd(
        nextUsage,
      );

      // =======================================================================
      // FREE ACTION
      // =======================================================================

      if (!shouldShowAd) {
        debugPrint(
          'AdGate → FREE',
        );

        await action();

        final newUsage =
        await _storage.incrementRewardedUsage();

        debugPrint(
          'AdGate → Usage updated: $newUsage',
        );

        return;
      }

      // =======================================================================
      // AD REQUIRED
      // =======================================================================

      debugPrint(
        'AdGate → AD REQUIRED → $adId',
      );

      // IMPORTANT:
      //
      // Ad loading starts ONLY after the user taps the action.
      //
      // Nothing is loaded when ANC/PNC screen opens.

      ref.read(
        rewardedAdProvider.notifier,
      ).load(
        adId: adId,
      );

      // =======================================================================
      // ALWAYS SHOW LOADING DIALOG FIRST
      // =======================================================================

      final loadingResult =
      await WatchAdDialog.showLoading(
        ref: ref,
        adId: adId,
      );

      // =======================================================================
      // AD FAILED / UNAVAILABLE
      // =======================================================================

      if (loadingResult ==
          WatchAdResult.continueAction) {
        debugPrint(
          'AdGate → Ad unavailable → '
              'Continue action',
        );

        await action();

        final newUsage =
        await _storage.incrementRewardedUsage();

        debugPrint(
          'AdGate → Usage updated: $newUsage',
        );

        return;
      }

      // =======================================================================
      // AD READY
      // =======================================================================

      if (loadingResult ==
          WatchAdResult.showAd) {
        debugPrint(
          'AdGate → Ad loaded → '
              'Show Watch Ad dialog',
        );

        final watchResult =
        await WatchAdDialog.showWatchAd(
          ref: ref,
          adId: adId,
        );

        // =====================================================================
        // USER CLOSED WATCH AD
        // =====================================================================

        if (watchResult ==
            WatchAdResult.cancelled) {
          debugPrint(
            'AdGate → User closed Watch Ad '
                'dialog → NO ACTION',
          );

          return;
        }

        // =====================================================================
        // USER ACCEPTED WATCH AD
        // =====================================================================

        if (watchResult ==
            WatchAdResult.showAd) {
          debugPrint(
            'AdGate → User accepted → '
                'Show rewarded ad → $adId',
          );

          final rewarded =
          await ref
              .read(
            rewardedAdProvider.notifier,
          )
              .showReady(
            adId: adId,
          );

          // ===================================================================
          // REWARDED AD RESULT
          // ===================================================================

          if (!rewarded) {
            debugPrint(
              'AdGate → Rewarded ad failed '
                  'or reward not earned',
            );

            return;
          }

          // ===================================================================
          // ACTION AFTER SUCCESSFUL REWARD
          // ===================================================================

          debugPrint(
            'AdGate → Reward earned → '
                'Continue action',
          );

          await action();

          final newUsage =
          await _storage.incrementRewardedUsage();

          debugPrint(
            'AdGate → Usage updated: '
                '$newUsage',
          );

          return;
        }
      }

      // =========================================================================
      // SAFETY FALLBACK
      // =========================================================================

      debugPrint(
        'AdGate → Unexpected ad state',
      );
    } finally {
      _isProcessing = false;
    }
  }

  // ===========================================================================
  // TESTING
  // ===========================================================================

  Future<void> resetForTesting() async {
    await _storage.resetRewardedUsage();

    debugPrint(
      'AdGate → Rewarded usage reset',
    );
  }

  Future<void> expireTrialForTesting() async {
    final expiredDate =
    DateTime.now().subtract(
      const Duration(days: 6),
    );

    await _storage.saveFirstInstallDate(
      expiredDate,
    );

    debugPrint(
      'AdGate → TEST → Trial expired',
    );
  }

  Future<void> resetTrialForTesting() async {
    await _storage.resetFirstInstallDate();

    debugPrint(
      'AdGate → Trial reset',
    );
  }

  Future<void> resetAllForTesting() async {
    await _storage.resetAdGateForTesting();

    debugPrint(
      'AdGate → Trial + usage reset',
    );
  }
}