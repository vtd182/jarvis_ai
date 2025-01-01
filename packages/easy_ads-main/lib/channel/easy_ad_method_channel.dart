import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'easy_ad_platform_interface.dart';

/// An implementation of [EasyAdPlatform] that uses method channels.
class MethodChannelEasyAd extends EasyAdPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('easy_ads_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool?> getConsentResult() async {
    return await methodChannel.invokeMethod<bool?>('hasConsentForPurposeOne');
  }

  @override
  Future<void> showLoadingAd(int color) async {
    return await methodChannel.invokeMethod('showLoadingAd', color);
  }

  @override
  Future<void> hideLoadingAd() async {
    return await methodChannel.invokeMethod('hideLoadingAd');
  }
}
