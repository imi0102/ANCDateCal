import 'package:anc_date_calculator/core/enum/enums.dart';
import 'package:anc_date_calculator/features/date_calculator/providers/theme_provider.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const DateSelectorCard(type: DateType.pnc,),
            const SizedBox(height: 14),
            ActionButtons(dateState?.pncDate),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.separated(
                itemCount: pncPeriods.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final p = pncPeriods[index];

                  final DateTime? fromDate;
                  final DateTime? toDate;

                  if (dateState?.pncDate == null) {
                    fromDate = null;
                    toDate = null;
                  } else {
                    final base = dateState!.pncDate!;
                    final prevDays = index == 0
                        ? 0
                        : pncPeriods[index - 1]['days'] as int;

                    fromDate = index == 0
                        ? base
                        : DateCalculator.startDate(base, prevDays);

                    toDate = DateCalculator.endDate(base, p['days'] as int);
                  }

                  return ResultCard(
                    label: p['label'].toString(),
                    fromDate: fromDate,
                    toDate: toDate,
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
