import 'package:anc_date_calculator/features/date_calculator/domain/entities/visit_period.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../../core/ads/banner_ad_provider.dart';

class BannerAdWidget extends ConsumerWidget {
  final String adUnitId;
  final VisitType visitType;

  const BannerAdWidget({
    super.key,
    required this.adUnitId,
    required this.visitType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (adUnitId.isEmpty) return const SizedBox.shrink();

    final ad = ref.watch(
      bannerAdProvider((
      adUnitId: adUnitId,
      visitType: visitType,
      )),
    );

    if (ad == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: SizedBox(
        width: ad.size.width.toDouble(),
        height: ad.size.height.toDouble(),
        child: AdWidget(ad: ad),
      ),
    );
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
