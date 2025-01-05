import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'easy_ad_method_channel.dart';

abstract class EasyAdPlatform extends PlatformInterface {
  /// Constructs a EasyAd_2Platform.
  EasyAdPlatform() : super(token: _token);

  static final Object _token = Object();

  static EasyAdPlatform _instance = MethodChannelEasyAd();

  /// The default instance of [EasyAdPlatform] to use.
  ///
  /// Defaults to [MethodChannelEasyAd].
  static EasyAdPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [EasyAdPlatform] when
  /// they register themselves.
  static set instance(EasyAdPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> getConsentResult() {
    throw UnimplementedError('consentResult() has not been implemented.');
  }

  Future<void> showLoadingAd(int color) {
    throw UnimplementedError('showLoadingInter() has not been implemented.');
  }

  Future<void> hideLoadingAd() {
    throw UnimplementedError('showLoadingInter() has not been implemented.');
  }
}
