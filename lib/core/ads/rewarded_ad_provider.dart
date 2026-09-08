import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

final rewardedAdProvider =
StateNotifierProvider<RewardedAdNotifier, RewardedAdState>(
      (ref) => RewardedAdNotifier(),
);

class RewardedAdState {
  final RewardedAd? ad;
  final bool isLoading;
  final String? adId;

  const RewardedAdState({
    this.ad,
    this.isLoading = false,
    this.adId,
  });

  bool get isReady => ad != null;
}

class RewardedAdNotifier
    extends StateNotifier<RewardedAdState> {
  RewardedAdNotifier()
      : super(const RewardedAdState());

  bool _isShowing = false;
  String? _loadingAdId;

  // ------------------------------------------------------------
  // LOAD AD
  // ------------------------------------------------------------

  void _load(String adId) {
    if (kIsWeb) return;

    if (!Platform.isAndroid && !Platform.isIOS) {
      return;
    }

    if (adId.isEmpty) {
      return;
    }

    // Already loading same ad.
    if (state.isLoading && _loadingAdId == adId) {
      return;
    }

    // Already have the requested ad.
    if (state.isReady && state.adId == adId) {
      return;
    }

    // If another ad ID is loaded, dispose it.
    if (state.ad != null && state.adId != adId) {
      state.ad?.dispose();
      state = const RewardedAdState();
    }

    // Don't load another ad while showing.
    if (_isShowing) {
      return;
    }

    _loadingAdId = adId;

    state = RewardedAdState(
      isLoading: true,
      adId: adId,
    );

    debugPrint(
      'RewardedAd → Loading → $adId',
    );

    RewardedAd.load(
      adUnitId: adId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          // Ignore old/stale load callbacks.
          if (_loadingAdId != adId) {
            ad.dispose();
            return;
          }

          state = RewardedAdState(
            ad: ad,
            adId: adId,
          );

          debugPrint(
            'RewardedAd → Loaded → $adId',
          );
        },
        onAdFailedToLoad: (error) {
          if (_loadingAdId != adId) {
            return;
          }

          state = const RewardedAdState();

          _loadingAdId = null;

          debugPrint(
            'RewardedAd → Failed → $adId',
          );

          debugPrint(
            'RewardedAd → Error → $error',
          );
        },
      ),
    );
  }

  // ------------------------------------------------------------
  // SHOW AD
  // ------------------------------------------------------------

  Future<bool> show({
    required String adId,
  }) async {
    if (kIsWeb) {
      return false;
    }

    if (!Platform.isAndroid && !Platform.isIOS) {
      return false;
    }

    if (adId.isEmpty) {
      return false;
    }

    // Another ad is already showing.
    if (_isShowing) {
      debugPrint(
        'RewardedAd → Already showing',
      );

      return false;
    }

    // No ad loaded.
    if (!state.isReady) {
      debugPrint(
        'RewardedAd → Not ready → $adId',
      );

      // Start loading requested ID.
      _load(adId);

      return false;
    }

    // Loaded ad belongs to another ID.
    if (state.adId != adId) {
      debugPrint(
        'RewardedAd → Ad ID mismatch',
      );

      state.ad?.dispose();

      state = const RewardedAdState();

      _loadingAdId = null;

      _load(adId);

      return false;
    }

    final ad = state.ad!;

    // Remove from state immediately.
    state = const RewardedAdState();

    _isShowing = true;
    _loadingAdId = null;

    bool rewarded = false;

    try {
      await ad.show(
        onUserEarnedReward: (_, reward) {
          rewarded = true;

          debugPrint(
            'RewardedAd → Reward earned → '
                '${reward.amount} ${reward.type}',
          );
        },
      );
    } catch (e) {
      debugPrint(
        'RewardedAd → Show error → $e',
      );
    } finally {
      ad.dispose();

      _isShowing = false;

      // Preload next ad using SAME ID.
      _load(adId);
    }

    return rewarded;
  }

  // ------------------------------------------------------------
  // PRELOAD
  // ------------------------------------------------------------

  void preload({
    required String adId,
  }) {
    _load(adId);
  }

  // ------------------------------------------------------------
  // DISPOSE
  // ------------------------------------------------------------

  @override
  void dispose() {
    state.ad?.dispose();

    super.dispose();
  }
}