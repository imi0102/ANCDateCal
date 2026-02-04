import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_ids.dart';

final rewardedAdProvider =
StateNotifierProvider<RewardedAdNotifier, RewardedAdState>(
      (ref) => RewardedAdNotifier(),
);

class RewardedAdState {
  final RewardedAd? ad;
  final bool isLoading;

  const RewardedAdState({
    this.ad,
    this.isLoading = false,
  });

  bool get isReady => ad != null;
}

class RewardedAdNotifier extends StateNotifier<RewardedAdState> {
  RewardedAdNotifier() : super(const RewardedAdState()) {
    _load();
  }

  bool _isShowing = false;

  void _load() {
    if (kIsWeb) return;
    if (!Platform.isAndroid && !Platform.isIOS) return;
    if (state.isLoading || state.ad != null) return;

    state = const RewardedAdState(isLoading: true);

    RewardedAd.load(
      adUnitId: AdIds.rewarded,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          state = RewardedAdState(ad: ad);
        },
        onAdFailedToLoad: (_) {
          state = const RewardedAdState();
        },
      ),
    );
  }

  /// Show ad (always instant if ready)
  Future<bool> show() async {
    if (!state.isReady || _isShowing) return false;

    _isShowing = true;
    bool rewarded = false;

    await state.ad!.show(
      onUserEarnedReward: (_, __) {
        rewarded = true;
      },
    );

    state.ad!.dispose();
    _isShowing = false;

    // Immediately preload next ad
    state = const RewardedAdState();
    _load();

    return rewarded;
  }
}
