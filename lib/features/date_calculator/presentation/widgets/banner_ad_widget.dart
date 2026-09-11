import 'package:anc_date_calculator/core/services/remote_config_service.dart';
import 'package:anc_date_calculator/features/date_calculator/domain/entities/visit_period.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../../core/ads/banner_ad_provider.dart';

import 'dart:async';

import 'package:anc_date_calculator/features/date_calculator/domain/entities/visit_period.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../../core/ads/banner_ad_provider.dart';

class BannerAdWidget extends ConsumerStatefulWidget {
  final String adUnitId;
  final VisitType visitType;

  const BannerAdWidget({
    super.key,
    required this.adUnitId,
    required this.visitType,
  });

  @override
  ConsumerState<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends ConsumerState<BannerAdWidget> {
  Timer? _loadingTimer;
  bool _showReservedSpace = true;

  @override
  void initState() {
    super.initState();
    final remoteConfig = RemoteConfigService.instance;

    if (!remoteConfig.enableBannerAds) {
      return;
    }
    // Give the ad some time to load.
    // If it does not load, remove the reserved space.
    _loadingTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showReservedSpace = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!RemoteConfigService.instance.enableBannerAds) {
      return const SizedBox.shrink();
    }
    if (widget.adUnitId.isEmpty) {
      return const SizedBox.shrink();
    }

    final ad = ref.watch(
      bannerAdProvider((
        adUnitId: widget.adUnitId,
        visitType: widget.visitType,
      )),
    );

    // Ad successfully loaded.
    if (ad != null) {
      _loadingTimer?.cancel();

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: SizedBox(
          width: ad.size.width.toDouble(),
          height: ad.size.height.toDouble(),
          child: AdWidget(ad: ad),
        ),
      );
    }

    // Ad is still loading.
    if (_showReservedSpace) {
      return const SizedBox(width: 320, height: 50);
    }

    // Ad failed / did not load.
    return const SizedBox.shrink();
  }
}

/*
class BannerAdWidget extends ConsumerWidget {
  const BannerAdWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banner = ref.watch(bannerAdProvider);

    if (banner == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: SizedBox(
        width: banner.size.width.toDouble(),
        height: banner.size.height.toDouble(),
        child: AdWidget(ad: banner),
      ),
    );
  }
}*/
