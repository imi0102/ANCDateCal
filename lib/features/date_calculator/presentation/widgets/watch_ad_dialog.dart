import 'package:anc_date_calculator/core/ads/rewarded_ad_provider.dart';
import 'package:anc_date_calculator/core/providers/navigator_key_provider.dart';
import 'package:anc_date_calculator/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum WatchAdResult { showAd, cancelled, continueAction }

class WatchAdDialog {
  // ===========================================================================
  // LOADING DIALOG
  // ===========================================================================

  static Future<WatchAdResult> showLoading({
    required Ref ref,
    required String adId,
  }) async {
    final context = ref.read(navigatorKeyProvider).currentContext;

    if (context == null) {
      debugPrint('WatchAdDialog → No context available');

      return WatchAdResult.continueAction;
    }

    final result = await showDialog<WatchAdResult>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return _AdLoadingDialog(adId: adId);
      },
    );

    return result ?? WatchAdResult.continueAction;
  }

  // ===========================================================================
  // WATCH AD DIALOG
  // ===========================================================================

  static Future<WatchAdResult> showWatchAd({
    required Ref ref,
    required String adId,
  }) async {
    final context = ref.read(navigatorKeyProvider).currentContext;

    if (context == null) {
      debugPrint('WatchAdDialog → No context available');

      return WatchAdResult.continueAction;
    }

    final result = await showDialog<WatchAdResult>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return _WatchAdDialog(adId: adId);
      },
    );

    return result ?? WatchAdResult.cancelled;
  }
}

// =============================================================================
// LOADING DIALOG
// =============================================================================

class _AdLoadingDialog extends ConsumerStatefulWidget {
  final String adId;

  const _AdLoadingDialog({required this.adId});

  @override
  ConsumerState<_AdLoadingDialog> createState() => _AdLoadingDialogState();
}

class _AdLoadingDialogState extends ConsumerState<_AdLoadingDialog> {
  bool _closed = false;

  @override
  void initState() {
    super.initState();

    ref.listenManual<RewardedAdState>(rewardedAdProvider, (previous, next) {
      _checkStatus(next);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final state = ref.read(rewardedAdProvider);

      _checkStatus(state);
    });
  }

  void _checkStatus(RewardedAdState state) {
    if (!mounted || _closed) {
      return;
    }

    final item = state.getAd(widget.adId);

    if (item.isReady) {
      _closed = true;

      Navigator.of(context).pop(WatchAdResult.showAd);

      return;
    }

    if (item.isFailed) {
      _closed = true;

      Navigator.of(context).pop(WatchAdResult.continueAction);

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.ads_click_rounded,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Preparing Ad',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),

            const CircularProgressIndicator(
              strokeWidth: 3,
              color: AppTheme.primaryColor,
            ),

            const SizedBox(height: 20),

            Text(
              'Please wait while the advertisement is being prepared.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.primaryColor.withValues(alpha:0.60),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// WATCH AD DIALOG
// =============================================================================

class _WatchAdDialog extends StatelessWidget {
  final String adId;

  const _WatchAdDialog({required this.adId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha:0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.play_circle_outline_rounded,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Watch Ad',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        'Watch a short advertisement to continue.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppTheme.primaryColor.withValues(alpha:0.60),
          height: 1.4,
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        TextButton(
          onPressed: () {
            // IMPORTANT:
            // Closing means NO ACTION.
            Navigator.of(context).pop(WatchAdResult.cancelled);
          },
          child: const Text(
            'Close',
            style: TextStyle(color: AppTheme.primaryColor),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
          ),
          onPressed: () {
            Navigator.of(context).pop(WatchAdResult.showAd);
          },
          child: const Text(
            'Watch Ad',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
