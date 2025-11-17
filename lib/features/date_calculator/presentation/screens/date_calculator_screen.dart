import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/periods.dart';
import '../../../../core/utils/date_calculator.dart';
import '../widgets/date_selector_card.dart';
import '../widgets/result_card.dart';
import '../widgets/action_buttons.dart';
import '../../providers/date_provider.dart';

class DateCalculatorScreen extends ConsumerWidget {
  const DateCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(dateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Date Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => ref.read(dateProvider.notifier).clear(),
            tooltip: 'Clear saved date',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const DateSelectorCard(),
            const SizedBox(height: 14),
            ActionButtons(selected),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.separated(
                itemCount: periods.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final p = periods[index];
                  final dt = selected == null
                      ? null
                      : DateCalculator.calculate(selected, p['days'] as int);
                  return ResultCard(label: p['label'].toString(), date: dt);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
