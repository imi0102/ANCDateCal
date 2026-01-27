import 'package:anc_date_calculator/core/constants/periods.dart';
import 'package:anc_date_calculator/core/enum/enums.dart';
import 'package:anc_date_calculator/core/utils/date_calculator.dart';
import 'package:anc_date_calculator/features/date_calculator/providers/date_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../widgets/action_buttons.dart';
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
            const DateSelectorCard(type: DateType.anc),
            const SizedBox(height: 14),
            ActionButtons(dateState?.ancDate),
            const SizedBox(height: 14),

            Expanded(
              child: ListView.separated(
                itemCount: ancPeriods.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final p = ancPeriods[index];
                  final isSingle = p['single'] == true;

                  DateTime? fromDate;
                  DateTime? toDate;

                  if (dateState?.ancDate == null) {
                    fromDate = null;
                    toDate = null;
                  } else {
                    final base = dateState!.ancDate!;
                    final days = p['days'] as int;

                    if (isSingle) {
                      // ✅ EDD → only ONE date
                      fromDate = null;
                      toDate = DateCalculator.endDate(base, days);
                    } else {
                      final prevDays = index == 0
                          ? 0
                          : ancPeriods[index - 1]['days'] as int;

                      fromDate = DateCalculator.startDate(base, prevDays);
                      toDate = DateCalculator.endDate(base, days);
                    }
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
