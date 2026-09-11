import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../services/remote_config_service.dart';
import '../utils/version_utils.dart';

class ForceUpdateService {
  static Future<bool> shouldForceUpdate() async {
    if (kIsWeb) {
      return false;
    }

    final remoteConfig =
        RemoteConfigService.instance;

    final forceUpdate =
        remoteConfig.forceUpdate;

    final minimumVersion =
        remoteConfig.minimumAppVersion;

    final packageInfo =
    await PackageInfo.fromPlatform();

    final installedVersion =
        packageInfo.version;

    debugPrint(
      'ForceUpdate → '
          'force_update = $forceUpdate',
    );

    debugPrint(
      'ForceUpdate → '
          'installed_version = $installedVersion',
    );

    debugPrint(
      'ForceUpdate → '
          'minimum_version = $minimumVersion',
    );

    if (!forceUpdate) {
      debugPrint(
        'ForceUpdate → Disabled',
      );

      return false;
    }

    final needsUpdate =
    VersionUtils.isVersionLessThan(
      installedVersion,
      minimumVersion,
    );

    debugPrint(
      'ForceUpdate → '
          'needs_update = $needsUpdate',
    );

    return needsUpdate;
  }
}