import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';


class PdfGenerator {
  static Future<Uint8List> makePdfBytes(DateTime base, List<Map<String, dynamic>> periods, DateTime Function(DateTime, int) calculate) async {
    final pdf = pw.Document();
    final df = DateFormat('dd MMM yyyy');


    pdf.addPage(pw.Page(build: (ctx) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Date Calculation', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Text('Selected Date: ${df.format(base)}'),
          pw.SizedBox(height: 12),
          ...periods.map((p) {
            final label = p['label'] as String;
            final days = p['days'] as int;
            final date = calculate(base, days);
            return pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 6),
              child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text(label), pw.Text(df.format(date))]),
            );
          }).toList(),
        ],
      );
    }));


    return pdf.save();
  }
}