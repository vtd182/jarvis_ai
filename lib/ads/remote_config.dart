import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfig {
  static final _remoteConfig = FirebaseRemoteConfig.instance;

  static Future<void> init() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 15),
          minimumFetchInterval: Duration.zero,
        ),
      );
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static void getRemoteConfig() {
    banner_all = _remoteConfig.getBool('banner_all');
    inter_knowledge_detail = _remoteConfig.getBool('inter_knowledge_detail');
    open_resume = _remoteConfig.getBool('open_resume');
    inter_create_prompt = _remoteConfig.getBool('inter_create_prompt');
  }

  /// remote config value here
  static bool banner_all = true;

  static bool inter_knowledge_detail = true;

  static bool open_resume = true;

  static bool inter_create_prompt = true;
}
