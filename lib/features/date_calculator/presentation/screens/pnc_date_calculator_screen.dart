import 'package:anc_date_calculator/core/ads/ad_ids.dart';
import 'package:anc_date_calculator/features/date_calculator/domain/entities/visit_period.dart';
import 'package:anc_date_calculator/features/date_calculator/presentation/widgets/banner_ad_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/periods.dart';
import '../../../../core/utils/date_calculator.dart';
import '../widgets/date_selector_card.dart';
import '../widgets/result_card.dart';
import '../widgets/action_buttons.dart';
import '../../providers/date_provider.dart';

class PNCDateCalculatorScreen extends ConsumerWidget {
  const PNCDateCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateState = ref.watch(dateProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const DateSelectorCard(
              visitType: VisitType.pnc,
            ),

            const SizedBox(height: 14),

            BannerAdWidget(
              adUnitId: AdIds.bannerPncAdUnitId,
              visitType: VisitType.pnc,
            ),

            const SizedBox(height: 14),

            ActionButtons(
              baseDate: dateState?.pncDate,
              visitType: VisitType.pnc,
            ),

            const SizedBox(height: 14),

            ...List.generate(
              pncPeriods.length,
                  (index) {
                final range = dateState?.pncDate == null
                    ? null
                    : DateCalculator.calculateRange(
                  base: dateState!.pncDate!,
                  periods: pncPeriods,
                  index: index,
                  visitType: VisitType.pnc,
                );

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == pncPeriods.length - 1 ? 0 : 12,
                  ),
                  child: ResultCard(
                    label: pncPeriods[index].label,
                    fromDate: range?.from,
                    toDate: range?.to,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
    
/*
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const DateSelectorCard(visitType: VisitType.pnc),
            const SizedBox(height: 14),
            BannerAdWidget(
              adUnitId: AdIds.bannerPncAdUnitId,
              visitType: VisitType.pnc,
            ),

            ActionButtons(
              baseDate: dateState?.pncDate,
              visitType: VisitType.pnc,
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.separated(
                itemCount: pncPeriods.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final range = dateState?.pncDate == null
                      ? null
                      : DateCalculator.calculateRange(
                          base: dateState!.pncDate!,
                          periods: pncPeriods,
                          index: index,
                          visitType: VisitType.pnc,
                        );

                  return ResultCard(
                    label: pncPeriods[index].label,
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
*/
  }
}
