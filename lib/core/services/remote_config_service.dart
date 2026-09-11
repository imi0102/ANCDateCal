import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  RemoteConfigService._();

  static final RemoteConfigService instance =
  RemoteConfigService._();

  final FirebaseRemoteConfig _remoteConfig =
      FirebaseRemoteConfig.instance;

  // ===========================================================================
  // INITIALIZE
  // ===========================================================================

  Future<void> initialize() async {
    debugPrint('');
    debugPrint('==================================================');
    debugPrint('REMOTE CONFIG → INITIALIZING');
    debugPrint('==================================================');

    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),

        // For testing use Duration.zero.
        // Production can use Duration(hours: 1).
        minimumFetchInterval: Duration.zero,
      ),
    );

    await _remoteConfig.setDefaults({
      'enable_banner_ads': false,
      'enable_rewarded_ads': false,
      'rewarded_ad_frequency': 3,
      'maintenance_mode': false,
      'force_update': false,
      'minimum_app_version': "1.0.0",
    });

    debugPrint(
      'REMOTE CONFIG → Defaults set',
    );

    try {
      final activated =
      await _remoteConfig.fetchAndActivate();

      debugPrint(
        'REMOTE CONFIG → fetchAndActivate: $activated',
      );

      _printAllValues();

      debugPrint('');
      debugPrint(
        'REMOTE CONFIG → INITIALIZATION COMPLETE',
      );
      debugPrint('==================================================');
      debugPrint('');
    } catch (e, stackTrace) {
      debugPrint(
        'REMOTE CONFIG → ERROR: $e',
      );

      debugPrint(
        'REMOTE CONFIG → STACK: $stackTrace',
      );

      // Still print defaults/current values.
      _printAllValues();
    }
  }

  // ===========================================================================
  // PRINT ALL VALUES
  // ===========================================================================

  void _printAllValues() {
    debugPrint('');
    debugPrint('--------------------------------------------------');
    debugPrint('REMOTE CONFIG → ALL VALUES');
    debugPrint('--------------------------------------------------');

    for (final entry in _remoteConfig.getAll().entries) {
      debugPrint(
        'REMOTE CONFIG → '
            '${entry.key} = ${entry.value.asString()} '
            '[source: ${entry.value.source}]',
      );
    }

    debugPrint('--------------------------------------------------');

    // Individual important values
    debugPrint(
      'REMOTE CONFIG → enable_banner_ads = '
          '${_remoteConfig.getBool('enable_banner_ads')}',
    );

    debugPrint(
      'REMOTE CONFIG → enable_rewarded_ads = '
          '${_remoteConfig.getBool('enable_rewarded_ads')}',
    );

    debugPrint(
      'REMOTE CONFIG → rewarded_ad_frequency = '
          '${_remoteConfig.getInt('rewarded_ad_frequency')}',
    );

    debugPrint(
      'REMOTE CONFIG → maintenance_mode = '
          '${_remoteConfig.getBool('maintenance_mode')}',
    );

    debugPrint(
      'REMOTE CONFIG → force_update = '
          '${_remoteConfig.getBool('force_update')}',
    );
    debugPrint(
      'REMOTE CONFIG → force_update = '
          '${_remoteConfig.getString('minimum_app_version')}',
    );

    debugPrint('--------------------------------------------------');
  }

  // ===========================================================================
  // BANNER
  // ===========================================================================

  bool get enableBannerAds {
    final value =
    _remoteConfig.getBool('enable_banner_ads');

    debugPrint(
      'REMOTE CONFIG → READ → '
          'enable_banner_ads = $value',
    );

    return value;
  }


  // ===========================================================================
  // REWARDED
  // ===========================================================================

  bool get enableRewardedAds {
    final value =
    _remoteConfig.getBool('enable_rewarded_ads');

    debugPrint(
      'REMOTE CONFIG → READ → '
          'enable_rewarded_ads = $value',
    );

    return value;
  }

  // ===========================================================================
  // FREQUENCY
  // ===========================================================================

  int get rewardedAdFrequency {
    final value =
    _remoteConfig.getInt('rewarded_ad_frequency');

    debugPrint(
      'REMOTE CONFIG → READ → '
          'rewarded_ad_frequency = $value',
    );

    return value;
  }

  // ===========================================================================
  // MAINTENANCE
  // ===========================================================================

  bool get maintenanceMode {
    final value =
    _remoteConfig.getBool('maintenance_mode');

    debugPrint(
      'REMOTE CONFIG → READ → '
          'maintenance_mode = $value',
    );

    return value;
  }

  // ===========================================================================
  // FORCE UPDATE
  // ===========================================================================

  bool get forceUpdate {
    final value =
    _remoteConfig.getBool('force_update');

    debugPrint(
      'REMOTE CONFIG → READ → '
          'force_update = $value',
    );

    return value;
  }


  String get minimumAppVersion {
    final value =
    _remoteConfig.getString('minimum_app_version');

    debugPrint(
      'REMOTE CONFIG → READ → '
          'minimum_app_version = $value',
    );

    return value;
  }
}