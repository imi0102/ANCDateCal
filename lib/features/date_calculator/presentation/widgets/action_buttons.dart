import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/periods.dart';
import '../../../../core/services/platform_utils_io.dart';
import '../../../../core/utils/date_calculator.dart';
import '../../../../core/utils/pdf_generator.dart';

class ActionButtons extends ConsumerWidget {
  final DateTime? selected;
  const ActionButtons(this.selected, {super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platform = getPlatformUtils();


    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          onPressed: selected == null
              ? null
              : () async {
// Copy
            final df = DateFormat('dd MMM yyyy');
            final buffer = StringBuffer();
            buffer.writeln('Selected: ${df.format(selected!)}');
            for (final p in periods) {
              buffer.writeln('${p['label']}: ${DateCalculator.calculate(selected!, p['days'] as int)}');
            }
            await platform.copyToClipboard(buffer.toString());
            if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
          },
          icon: const Icon(Icons.copy_all),
          label: const Text('Copy'),
        ),


        ElevatedButton.icon(
          onPressed: selected == null
              ? null
              : () async {
// Share text
            final df = DateFormat('dd MMM yyyy');
            final buffer = StringBuffer();
            buffer.writeln('Date Calculation for ${df.format(selected!)}');
            for (final p in periods) {
              buffer.writeln('${p['label']}: ${DateCalculator.calculate(selected!, p['days'] as int)}');
            }
            await platform.shareText(buffer.toString());
          },
          icon: const Icon(Icons.share),
          label: const Text('Share'),
        ),


        ElevatedButton.icon(
          onPressed: selected == null
              ? null
              : () async {
            final bytes = await PdfGenerator.makePdfBytes(selected!, periods, DateCalculator.calculate);
            await platform.savePdfAndShare(bytes, 'date_calculation_${selected!.millisecondsSinceEpoch}.pdf');
          },
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text('Export PDF'),
        ),
      ],
    );
  }
}