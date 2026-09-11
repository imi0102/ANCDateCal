import 'package:anc_date_calculator/core/constants/periods.dart';
import 'package:anc_date_calculator/core/theme/app_theme.dart';
import 'package:anc_date_calculator/core/utils/date_calculator.dart';
import 'package:anc_date_calculator/core/utils/pdf_generator.dart';
import 'package:anc_date_calculator/features/date_calculator/domain/entities/visit_period.dart';
import 'package:anc_date_calculator/features/date_calculator/presentation/widgets/reward_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/platform_utils_io.dart';

class ActionButtons extends ConsumerWidget {
  final DateTime? baseDate;
  final VisitType visitType;

  const ActionButtons({
    super.key,
    required this.baseDate,
    required this.visitType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final df = DateFormat('dd/MM/yyyy, EEEE', 'gu_IN');
    final platform = getPlatformUtils();

    final periods = visitType == VisitType.anc ? ancPeriods : pncPeriods;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// ================= COPY =================
        RewardActionButton(
          icon: Icons.copy_all,
          label: 'કોપી',
          enabled: baseDate != null,
          visitType: visitType,
          onRewardedAction: () async {
            final buffer = StringBuffer();

            buffer.writeln(
              visitType == VisitType.anc
                  ? 'LMP તારીખ: ${df.format(baseDate!)}\n'
                  : 'ડિલિવરી તારીખ: ${df.format(baseDate!)}\n',
            );

            for (int i = 0; i < periods.length; i++) {
              final p = periods[i];
              final range = DateCalculator.calculateRange(
                base: baseDate!,
                periods: periods,
                index: i,
                visitType: visitType,
              );

              buffer.writeln('→ ${p.label}');
              buffer.writeln(df.format(range.from));

              if (!range.isSingle) {
                buffer.writeln(
                  DateCalculator.centerWordBetween(
                    df.format(range.from),
                    df.format(range.to!),
                    'થી',
                  ),
                );
                buffer.writeln(df.format(range.to!));
              }

              buffer.writeln();
            }

            await platform.copyToClipboard(buffer.toString());

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ક્લિપબોર્ડ પર કૉપિ કરી')),
              );
            }
          },
        ),

        /// ================= SHARE =================
        RewardActionButton(
          label: 'શેર',
          icon: Icons.share,
          enabled: baseDate != null,
          visitType: visitType,
          onRewardedAction: () async {
            final buffer = StringBuffer();

            buffer.writeln(
              visitType == VisitType.anc
                  ? 'LMP તારીખ: ${df.format(baseDate!)}\n'
                  : 'ડિલિવરી તારીખ: ${df.format(baseDate!)}\n',
            );

            for (int i = 0; i < periods.length; i++) {
              final p = periods[i];
              final range = DateCalculator.calculateRange(
                base: baseDate!,
                periods: periods,
                index: i,
                visitType: visitType,
              );

              buffer.writeln('→ ${p.label}');
              buffer.writeln(df.format(range.from));

              if (!range.isSingle) {
                buffer.writeln(
                  DateCalculator.centerWordBetween(
                    df.format(range.from),
                    df.format(range.to!),
                    'થી',
                  ),
                );
                buffer.writeln(df.format(range.to!));
              }

              buffer.writeln();
            }

            await platform.shareText(buffer.toString());
          },
        ),

        /// ================= PDF =================
        RewardActionButton(
          icon: Icons.picture_as_pdf,
          label: 'એક્સપોર્ટ PDF',
          enabled: baseDate != null,
          visitType: visitType,
          onRewardedAction: () async {
            final periods = visitType == VisitType.anc
                ? ancPeriods
                : pncPeriods;

            final bytes = await PdfGenerator.makePdfBytes(
              baseDate!,
              periods,
              (base, index) => DateCalculator.calculateRange(
                base: base,
                periods: periods,
                index: index,
                visitType: visitType,
              ),
            );

            await PdfGenerator.savePdfAndShare(
              bytes,
              '${visitType.name.toUpperCase()}_${baseDate!.millisecondsSinceEpoch}.pdf',
            );
          },
        ),
      ],
    );
  }
}
