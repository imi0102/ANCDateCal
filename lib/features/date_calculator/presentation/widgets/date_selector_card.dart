import 'dart:ui';
import 'package:anc_date_calculator/core/theme/app_theme.dart';
import 'package:anc_date_calculator/features/date_calculator/domain/entities/visit_period.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/date_provider.dart';
import 'package:intl/intl.dart';

class DateSelectorCard extends ConsumerWidget {
  final VisitType visitType;

  const DateSelectorCard({super.key, required this.visitType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateState = ref.watch(dateProvider);
    final df = DateFormat('dd/MM/yyyy, EEEE', 'gu_IN');

    final selectedDate = visitType == VisitType.anc
        ? dateState?.ancDate
        : dateState?.pncDate;

    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          helpText: visitType == VisitType.anc
              ? "LMP તારીખ પસંદ કરો"
              : "ડિલવરી તારીખ પસંદ કરો",
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: isDark
                    ? const ColorScheme.dark(
                        primary: Colors.teal, // header & selected date
                        onPrimary: Colors.white,
                        surface: Color(0xFF121212), // dialog bg
                        onSurface: Colors.white,
                      )
                    : const ColorScheme.light(
                        primary: AppTheme.primaryColor,
                        onPrimary: Colors.white,
                        surface: Colors.white,
                        onSurface: Colors.black,
                      ),
                dialogTheme: DialogThemeData(
                  backgroundColor: isDark
                      ? const Color(0xFF121212)
                      : Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );

        if (picked != null) {
          final notifier = ref.read(dateProvider.notifier);
          if (visitType == VisitType.anc) {
            notifier.setAncDate(picked);
          } else {
            notifier.setPncDate(picked);
          }
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.06)
                  : Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.4)
                    : Colors.black.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      visitType == VisitType.anc
                          ? 'LMP તારીખ પસંદ કરો'
                          : 'ડિલવરી તારીખ પસંદ કરો',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      selectedDate == null
                          ? 'તારીખ પસંદ કરવા માટે ટેપ કરો'
                          : df.format(selectedDate),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.calendar_month, size: 28),
                    if (selectedDate != null)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          final notifier = ref.read(dateProvider.notifier);
                          if (visitType == VisitType.anc) {
                            notifier.clearAnc();
                          } else {
                            notifier.clearPnc();
                          }
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*class DateSelectorCard extends ConsumerWidget {
  const DateSelectorCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateState = ref.watch(dateProvider);
    //final df = DateFormat('EEEE, dd MMM yyyy');
    final df = DateFormat('dd/MM/yyyy, EEEE', 'gu_IN');
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: dateState.selectedDate ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (picked != null) ref.read(dateProvider.notifier).setPncDate(picked);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.06)
                  : Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.06)
                      : Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ડિલવરી તારીખ પસંદ કરો',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Shimmer.fromColors(
                      baseColor: Theme.of(context).textTheme.bodyLarge!.color!,
                      highlightColor: Theme.of(
                        context,
                      ).textTheme.bodyMedium!.color!,
                      child: Text(
                        dateState?.selectedDate == null
                            ? 'ડિલવરી તારીખ પસંદ કરવા માટે ટેપ કરો'
                            : df.format(dateState!.selectedDate!),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.calendar_month, size: 28),
                    if (dateState!.loaded && dateState?.selectedDate != null) IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => ref.read(dateProvider.notifier).clearPnc(),
                      tooltip: 'Clear saved date',
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}*/
