import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

import 'date_calculator.dart';

typedef DateRangeCalculator =
    (DateTime from, DateTime to) Function(DateTime base, int index);

class PdfGenerator {
  static Future<Uint8List> makePdfBytes(
      DateTime base,
      List<Map<String, dynamic>> periods,
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

              pw.Text(
                'ડિલવરી તારીખ: ${df.format(base)}',
                style: baseStyle,
              ),

              pw.SizedBox(height: 12),

              ...List.generate(periods.length, (i) {
                final p = periods[i];
                final label = p['label'] as String;
                final range = rangeFn(base, i);

                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 6),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        child: pw.Text(
                          label,
                          style: baseStyle,
                        ),
                      ),
                      pw.Text(
                        '${df.format(range.$1)}\n'
                            '${DateCalculator.centerWordBetween(
                          df.format(range.$1),
                          df.format(range.$2),
                          'થી',
                        )}\n'
                            '${df.format(range.$2)}',
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
}

