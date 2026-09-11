import 'package:anc_date_calculator/core/ads/ad_gate_service.dart';
import 'package:anc_date_calculator/core/ads/ad_ids.dart';
import 'package:anc_date_calculator/core/ads/rewarded_ad_provider.dart';
import 'package:anc_date_calculator/core/theme/app_theme.dart';
import 'package:anc_date_calculator/features/date_calculator/domain/entities/visit_period.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RewardActionButton extends ConsumerWidget {
  final IconData icon;
  final String label;
  final Future<void> Function() onRewardedAction;
  final bool enabled;
  final VisitType visitType;

  const RewardActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onRewardedAction,
    required this.visitType,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: !enabled
          ? null
          : () async {
              if (context.mounted) {
                await ref
                    .read(adGateProvider)
                    .run(
                      adId: visitType == VisitType.anc
                          ? AdIds.rewardedAncAdUnitId
                          : AdIds.rewardedPncAdUnitId,
                      action: onRewardedAction,
                    );
              }
              /*
              final rewarded = await ref
                  .read(rewardedAdProvider.notifier)
                  .show();

              if (kIsWeb || (rewarded && context.mounted)) {
                await onRewardedAction();
              }
*/

              // await onRewardedAction();
            },
      icon: Icon(
        icon,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : AppTheme.primaryColor,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : AppTheme.primaryColor,
        ),
      ),
    );
  }
}
