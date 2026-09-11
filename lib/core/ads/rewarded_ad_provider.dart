import 'dart:async';

import 'package:anc_date_calculator/core/services/remote_config_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

final rewardedAdProvider =
StateNotifierProvider<
    RewardedAdNotifier,
    RewardedAdState>(
      (ref) => RewardedAdNotifier(),
);

// =============================================================================
// STATUS
// =============================================================================

enum RewardedAdStatus {
  idle,
  loading,
  ready,
  failed,
}

// =============================================================================
// AD ITEM
// =============================================================================

class RewardedAdItem {
  final RewardedAd? ad;
  final RewardedAdStatus status;

  const RewardedAdItem({
    this.ad,
    this.status = RewardedAdStatus.idle,
  });

  bool get isReady =>
      ad != null &&
          status == RewardedAdStatus.ready;

  bool get isLoading =>
      status == RewardedAdStatus.loading;

  bool get isFailed =>
      status == RewardedAdStatus.failed;
}

// =============================================================================
// STATE
// =============================================================================

class RewardedAdState {
  final Map<String, RewardedAdItem> ads;

  const RewardedAdState({
    this.ads = const {},
  });

  RewardedAdItem getAd(String adId) {
    return ads[adId] ??
        const RewardedAdItem();
  }

  RewardedAdState copyWithAd(
      String adId,
      RewardedAdItem item,
      ) {
    final newAds =
    Map<String, RewardedAdItem>.from(
      ads,
    );

    newAds[adId] = item;

    return RewardedAdState(
      ads: newAds,
    );
  }

  RewardedAdState removeAd(
      String adId,
      ) {
    final newAds =
    Map<String, RewardedAdItem>.from(
      ads,
    );

    newAds.remove(adId);

    return RewardedAdState(
      ads: newAds,
    );
  }
}

// =============================================================================
// NOTIFIER
// =============================================================================

class RewardedAdNotifier
    extends StateNotifier<RewardedAdState> {
  RewardedAdNotifier()
      : super(
    const RewardedAdState(),
  );

  final Set<String> _loadingIds = {};

  /// Used to ignore old callbacks if another load
  /// for the same ad ID has already started.
  final Map<String, int> _loadGeneration = {};

  bool _isShowing = false;

  // ===========================================================================
  // PLATFORM CHECK
  // ===========================================================================

  bool get _isSupportedPlatform {
    if (kIsWeb) {
      return false;
    }

    return defaultTargetPlatform ==
        TargetPlatform.android ||
        defaultTargetPlatform ==
            TargetPlatform.iOS;
  }

  // ===========================================================================
  // REMOTE CONFIG CHECK
  // ===========================================================================

  bool get _isRewardedAdEnabled {
    return RemoteConfigService
        .instance
        .enableRewardedAds;
  }

  // ===========================================================================
  // LOAD
  // ===========================================================================

  void load({
    required String adId,
  }) {
    // -------------------------------------------------------------------------
    // REMOTE CONFIG
    // -------------------------------------------------------------------------

    if (!_isRewardedAdEnabled) {
      debugPrint(
        'RewardedAd → Disabled by Remote Config → '
            'Skip loading',
      );

      return;
    }

    // -------------------------------------------------------------------------
    // PLATFORM
    // -------------------------------------------------------------------------

    if (!_isSupportedPlatform) {
      debugPrint(
        'RewardedAd → Unsupported platform',
      );

      return;
    }

    // -------------------------------------------------------------------------
    // AD ID
    // -------------------------------------------------------------------------

    if (adId.isEmpty) {
      debugPrint(
        'RewardedAd → Empty ad ID',
      );

      return;
    }

    // -------------------------------------------------------------------------
    // ALREADY LOADING
    // -------------------------------------------------------------------------

    if (_loadingIds.contains(adId)) {
      debugPrint(
        'RewardedAd → Already loading → $adId',
      );

      return;
    }

    final currentItem =
    state.getAd(adId);

    // -------------------------------------------------------------------------
    // ALREADY READY
    // -------------------------------------------------------------------------

    if (currentItem.isReady) {
      debugPrint(
        'RewardedAd → Already ready → $adId',
      );

      return;
    }

    // -------------------------------------------------------------------------
    // DISPOSE OLD AD
    // -------------------------------------------------------------------------

    currentItem.ad?.dispose();

    _loadingIds.add(adId);

    // -------------------------------------------------------------------------
    // GENERATION
    // -------------------------------------------------------------------------

    final generation =
        (_loadGeneration[adId] ?? 0) + 1;

    _loadGeneration[adId] =
        generation;

    // -------------------------------------------------------------------------
    // LOADING STATE
    // -------------------------------------------------------------------------

    state = state.copyWithAd(
      adId,
      const RewardedAdItem(
        status: RewardedAdStatus.loading,
      ),
    );

    debugPrint(
      'RewardedAd → Loading → $adId',
    );

    // -------------------------------------------------------------------------
    // LOAD
    // -------------------------------------------------------------------------

    RewardedAd.load(
      adUnitId: adId,
      request: const AdRequest(),
      rewardedAdLoadCallback:
      RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          final isLatest =
              _loadGeneration[adId] ==
                  generation;

          if (!isLatest) {
            debugPrint(
              'RewardedAd → Old callback ignored → '
                  '$adId',
            );

            ad.dispose();
            return;
          }

          _loadingIds.remove(adId);

          // -------------------------------------------------------------------
          // REMOTE CONFIG MAY HAVE CHANGED WHILE LOADING
          // -------------------------------------------------------------------

          if (!_isRewardedAdEnabled) {
            debugPrint(
              'RewardedAd → Disabled after loading → '
                  'Dispose ad',
            );

            ad.dispose();

            state = state.copyWithAd(
              adId,
              const RewardedAdItem(
                status: RewardedAdStatus.idle,
              ),
            );

            return;
          }

          state = state.copyWithAd(
            adId,
            RewardedAdItem(
              ad: ad,
              status: RewardedAdStatus.ready,
            ),
          );

          debugPrint(
            'RewardedAd → Loaded → $adId',
          );
        },

        onAdFailedToLoad: (error) {
          final isLatest =
              _loadGeneration[adId] ==
                  generation;

          if (!isLatest) {
            return;
          }

          _loadingIds.remove(adId);

          state = state.copyWithAd(
            adId,
            const RewardedAdItem(
              status: RewardedAdStatus.failed,
            ),
          );

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

  // ===========================================================================
  // SHOW READY AD
  // ===========================================================================

  Future<bool> showReady({
    required String adId,
  }) async {
    // -------------------------------------------------------------------------
    // REMOTE CONFIG
    // -------------------------------------------------------------------------

    if (!_isRewardedAdEnabled) {
      debugPrint(
        'RewardedAd → Disabled by Remote Config → '
            'Do not show',
      );

      return false;
    }

    // -------------------------------------------------------------------------
    // PLATFORM
    // -------------------------------------------------------------------------

    if (!_isSupportedPlatform) {
      return false;
    }

    // -------------------------------------------------------------------------
    // AD ID
    // -------------------------------------------------------------------------

    if (adId.isEmpty) {
      return false;
    }

    // -------------------------------------------------------------------------
    // ALREADY SHOWING
    // -------------------------------------------------------------------------

    if (_isShowing) {
      debugPrint(
        'RewardedAd → Already showing',
      );

      return false;
    }

    // -------------------------------------------------------------------------
    // GET AD
    // -------------------------------------------------------------------------

    final item =
    state.getAd(adId);

    if (!item.isReady) {
      debugPrint(
        'RewardedAd → Ad is not ready → '
            '$adId',
      );

      return false;
    }

    final ad = item.ad!;

    // -------------------------------------------------------------------------
    // REMOVE READY AD BEFORE SHOWING
    // -------------------------------------------------------------------------

    state = state.copyWithAd(
      adId,
      const RewardedAdItem(
        status: RewardedAdStatus.idle,
      ),
    );

    _isShowing = true;

    final completer =
    Completer<bool>();

    bool rewardEarned = false;

    debugPrint(
      'RewardedAd → Showing → $adId',
    );

    // -------------------------------------------------------------------------
    // CALLBACKS
    // -------------------------------------------------------------------------

    ad.fullScreenContentCallback =
        FullScreenContentCallback(
          onAdShowedFullScreenContent:
              (ad) {
            debugPrint(
              'RewardedAd → Full screen shown → '
                  '$adId',
            );
          },

          onAdDismissedFullScreenContent:
              (ad) {
            debugPrint(
              'RewardedAd → Dismissed → '
                  '$adId',
            );

            ad.dispose();

            _isShowing = false;

            if (!completer.isCompleted) {
              completer.complete(
                rewardEarned,
              );
            }
          },

          onAdFailedToShowFullScreenContent:
              (ad, error) {
            debugPrint(
              'RewardedAd → Failed to show → '
                  '$adId',
            );

            debugPrint(
              'RewardedAd → Error → $error',
            );

            ad.dispose();

            _isShowing = false;

            if (!completer.isCompleted) {
              completer.complete(false);
            }
          },

          onAdImpression: (ad) {
            debugPrint(
              'RewardedAd → Impression → '
                  '$adId',
            );
          },

          onAdClicked: (ad) {
            debugPrint(
              'RewardedAd → Clicked → '
                  '$adId',
            );
          },
        );

    // -------------------------------------------------------------------------
    // SHOW
    // -------------------------------------------------------------------------

    try {
      ad.show(
        onUserEarnedReward:
            (
            AdWithoutView ad,
            RewardItem reward,
            ) {
          rewardEarned = true;

          debugPrint(
            'RewardedAd → Reward earned → '
                '${reward.amount} '
                '${reward.type}',
          );
        },
      );
    } catch (e) {
      debugPrint(
        'RewardedAd → Show exception → $e',
      );

      ad.dispose();

      _isShowing = false;

      if (!completer.isCompleted) {
        completer.complete(false);
      }
    }

    return completer.future;
  }

  // ===========================================================================
  // DISPOSE
  // ===========================================================================

  @override
  void dispose() {
    for (final item in state.ads.values) {
      item.ad?.dispose();
    }

    super.dispose();
  }
}