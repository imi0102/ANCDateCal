import 'dart:ui';
import 'package:anc_date_calculator/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/periods.dart';
import '../../../../core/services/platform_utils_io.dart';
import '../../../../core/utils/date_calculator.dart';
import '../../../../core/utils/pdf_generator.dart';

class ActionButtons extends ConsumerWidget {
  final DateTime? DeliveryDate;

  const ActionButtons(this.DeliveryDate, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platform = getPlatformUtils();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          onPressed: DeliveryDate == null
              ? null
              : () async {
                  // Copy
                  final df = DateFormat('dd/MM/yyyy, EEEE', 'gu_IN');
                  final buffer = StringBuffer();

                  buffer.writeln('ડિલવરી તારીખ: ${df.format(DeliveryDate!)}\n');

                  for (int i = 0; i < pncPeriods.length; i++) {
                    final p = pncPeriods[i];

                    // current period end
                    final DateTime toDate = DateCalculator.endDate(
                      DeliveryDate!,
                      p['days'] as int,
                    );

                    // previous period end + 1 = current start
                    final DateTime fromDate = i == 0
                        ? DeliveryDate!
                        : DateCalculator.startDate(
                            DeliveryDate!,
                            pncPeriods[i - 1]['days'] as int,
                          ).add(const Duration(days: 1));

                    buffer.writeln(
                        '→ ${p['label']}\n'
                            '${df.format(fromDate)}\n'
                            '${DateCalculator.centerWordBetween(df.format(fromDate), df.format(toDate), 'થી')}\n'
                            '${df.format(toDate)}\n'

                    );
                  }

                  await platform.copyToClipboard(buffer.toString());

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ક્લિપબોર્ડ પર કૉપિ કરી')),
                    );
                  }
                },
          icon: Icon(
            Icons.copy_all,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : AppTheme.primaryColor,
          ),
          label: Text(
            'કોપી',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : AppTheme.primaryColor,
            ),
          ),
        ),

        ElevatedButton.icon(
          onPressed: DeliveryDate == null
              ? null
              : () async {
                  // Share text
                  final df = DateFormat('dd/MM/yyyy, EEEE', 'gu_IN');
                  final buffer = StringBuffer();

                  buffer.writeln('ડિલવરી તારીખ: ${df.format(DeliveryDate!)}\n');

                  for (int i = 0; i < pncPeriods.length; i++) {
                    final p = pncPeriods[i];
                    final prevDays = i == 0 ? 0 : pncPeriods[i - 1]['days'] as int;

                    final fromDate = i == 0
                        ? DeliveryDate!
                        : DateCalculator.startDate(DeliveryDate!, prevDays);

                    final toDate = DateCalculator.endDate(
                      DeliveryDate!,
                      p['days'] as int,
                    );

                    buffer.writeln(
                        '→ ${p['label']}\n'
                            '${df.format(fromDate)}\n'
                            '${DateCalculator.centerWordBetween(df.format(fromDate), df.format(toDate), 'થી')}\n'
                            '${df.format(toDate)}\n'
                    );
                  }

                  await platform.shareText(buffer.toString());
                },
          icon: Icon(
            Icons.share,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : AppTheme.primaryColor,
          ),
          label: Text(
            'શેર',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : AppTheme.primaryColor,
            ),
          ),
        ),

        ElevatedButton.icon(
          onPressed: DeliveryDate == null
              ? null
              : () async {
                  final bytes = await PdfGenerator.makePdfBytes(
                    DeliveryDate!,
                    pncPeriods,
                    (DateTime base, int index) {
                      final prevDays = index == 0
                          ? 0
                          : pncPeriods[index - 1]['days'] as int;

                      final fromDate = index == 0
                          ? base
                          : DateCalculator.startDate(base, prevDays);

                      final toDate = DateCalculator.endDate(
                        base,
                        pncPeriods[index]['days'] as int,
                      );

                      return (fromDate, toDate);
                    },
                  );

                  await platform.savePdfAndShare(
                    bytes,
                    'PNC મુલાકાત ની તારીખો_${DeliveryDate!.millisecondsSinceEpoch}.pdf',
                  );
                },
          icon: Icon(
            Icons.picture_as_pdf,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : AppTheme.primaryColor,
          ),
          label: Text(
            'એક્સપોર્ટ PDF',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : AppTheme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
