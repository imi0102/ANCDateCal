import 'dart:typed_data';
import 'package:anc_date_calculator/features/date_calculator/domain/entities/date_range.dart';
import 'package:anc_date_calculator/features/date_calculator/domain/entities/visit_period.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../../../../core/utils/date_calculator.dart';
import '../../../../core/services/platform_utils_io.dart'; // uses the stub

typedef DateRangeCalculator = DateRange Function(DateTime base, int index);

class PdfGenerator {
  static Future<Uint8List> makePdfBytes(
      DateTime base,
      List<VisitPeriod> periods,
      DateRangeCalculator rangeFn,
      ) async {
    final pdf = pw.Document();
    final df = DateFormat('dd/MM/yyyy');

    final gujaratiFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/NotoSansGujarati-Regular.ttf'),
    );
    final baseStyle = pw.TextStyle(font: gujaratiFont);

    pdf.addPage(
      pw.Page(
        build: (ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'PNC મુલાકાત ની તારીખો',
                style: pw.TextStyle(
                  font: gujaratiFont,
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text('ડિલવરી તારીખ: ${df.format(base)}', style: baseStyle),
              pw.SizedBox(height: 12),
              ...List.generate(periods.length, (i) {
                final period = periods[i];
                final range = rangeFn(base, i);

                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 6),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(child: pw.Text(period.label, style: baseStyle)),
                      pw.Text(
                        range.isSingle
                            ? df.format(range.from)
                            : '${df.format(range.from)}\n${DateCalculator.centerWordBetween(df.format(range.from), df.format(range.to!), 'થી')}\n${df.format(range.to!)}',
                        style: baseStyle,
                        textAlign: pw.TextAlign.center,
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static Future<void> savePdfAndShare(Uint8List bytes, String fileName) async {
    final platform = getPlatformUtils();
    await platform.savePdfAndShare(bytes, fileName);
  }
}
