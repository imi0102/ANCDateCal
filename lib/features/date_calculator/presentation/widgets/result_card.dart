import 'dart:ui';
import 'package:anc_date_calculator/core/theme/app_theme.dart';
import 'package:anc_date_calculator/core/utils/date_calculator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ResultCard extends StatelessWidget {
  final String label;
  final DateTime? fromDate;
  final DateTime? toDate;

  const ResultCard({
    super.key,
    required this.label,
    required this.fromDate,
    required this.toDate,
  });

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd/MM/yyyy, EEEE', 'gu_IN');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.03)
                : Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ICON
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isDark
                      ? Colors.white
                      : AppTheme.primaryColor,
                ),
                child: Icon(
                  Icons.event,
                  color: isDark
                      ? AppTheme.primaryColor
                      : Colors.white,
                ),
              ),

              const SizedBox(width: 12),

              // CONTENT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LABEL
                    Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // DATE TEXT
                    Text(
                      _buildDateText(df),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? Colors.white
                            : AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 Handles:
  /// - EDD (single date)
  /// - ANC / PNC (range)
  /// - Null state
  String _buildDateText(DateFormat df) {
    // No date selected
    if (fromDate == null && toDate == null) {
      return '--';
    }

    // ✅ EDD → single date
    if (fromDate != null && toDate == null) {
      return df.format(fromDate!);
    }

    // ✅ Range (ANC / PNC)
    return '${df.format(fromDate!)}\n'
        '${DateCalculator.centerWordBetween(
      df.format(fromDate!),
      df.format(toDate!),
      'થી',
    )}\n'
        '${df.format(toDate!)}';
  }
}
