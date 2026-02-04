import 'package:anc_date_calculator/core/ads/rewarded_ad_provider.dart';
import 'package:anc_date_calculator/core/theme/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RewardActionButton extends ConsumerWidget {
  final IconData icon;
  final String label;
  final Future<void> Function() onRewardedAction;
  final bool enabled;

  const RewardActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onRewardedAction,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: !enabled
          ? null
          : () async {
              /*final rewarded = await ref
                  .read(rewardedAdProvider.notifier)
                  .show();

              if (kIsWeb || (rewarded && context.mounted)) {
                await onRewardedAction();
              }*/

              await onRewardedAction();
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
