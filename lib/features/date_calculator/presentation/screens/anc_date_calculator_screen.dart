import 'package:anc_date_calculator/core/ads/ad_ids.dart';
import 'package:anc_date_calculator/core/constants/periods.dart';
import 'package:anc_date_calculator/core/utils/date_calculator.dart';
import 'package:anc_date_calculator/features/date_calculator/domain/entities/visit_period.dart';
import 'package:anc_date_calculator/features/date_calculator/providers/date_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/action_buttons.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/date_selector_card.dart';
import '../widgets/result_card.dart'; // reuse your ResultCard widget

class ANCDateCalculatorScreen extends ConsumerWidget {
  final DateTime lmp;

  const ANCDateCalculatorScreen({super.key, required this.lmp});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateState = ref.watch(dateProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const DateSelectorCard(visitType: VisitType.anc),

            const SizedBox(height: 14),

            // BannerAdWidget(
            //   adUnitId: AdIds.bannerAncAdUnitId,
            //   visitType: VisitType.anc,
            // ),

            ActionButtons(
              baseDate: dateState?.ancDate,
              visitType: VisitType.anc,
            ),
            const SizedBox(height: 14),

            Expanded(
              child: ListView.separated(
                itemCount: ancPeriods.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final range = dateState?.ancDate == null
                      ? null
                      : DateCalculator.calculateRange(
                          base: dateState!.ancDate!,
                          periods: ancPeriods,
                          index: index,
                          visitType: VisitType.anc,
                        );

                  return ResultCard(
                    label: ancPeriods[index].label,
                    fromDate: range?.from,
                    toDate: range?.to,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
