import 'dart:io';
import 'package:anc_date_calculator/features/date_calculator/domain/entities/visit_period.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

final bannerAdProvider =
    Provider.family<BannerAd?, ({String adUnitId, VisitType visitType})>((
      ref,
      params,
    ) {
      final ad = BannerAd(
        adUnitId: params.adUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(),
      )..load();

      ref.onDispose(ad.dispose);
      return ad;
    });
