// ignore_for_file: deprecated_member_use

part of '../easy_ads.dart';

extension EasyAdsExtension on EasyAds {
  bool isTablet() {
    final double devicePixelRatio = ui.window.devicePixelRatio;
    final ui.Size size = ui.window.physicalSize;
    final double width = size.width;
    final double height = size.height;

    if (devicePixelRatio < 2 && (width >= 1000 || height >= 1000)) {
      return true;
    } else if (devicePixelRatio == 2 && (width >= 1920 || height >= 1920)) {
      return true;
    } else {
      return false;
    }
  }

  void fireNetworkInitializedEvent(AdNetwork adNetwork, bool status) {
    _onEventController.add(AdEvent(
      type: AdEventType.adNetworkInitialized,
      adNetwork: adNetwork,
      data: status,
    ));
  }

  void onAdLoadedMethod(AdNetwork adNetwork, AdUnitType adUnitType, Object? data) {
    _onEventController.add(AdEvent(
      type: AdEventType.adLoaded,
      adNetwork: adNetwork,
      adUnitType: adUnitType,
      data: data,
    ));
  }

  void onAdClickedMethod(AdNetwork adNetwork, AdUnitType adUnitType, Object? data) {
    _onEventController.add(AdEvent(
      type: AdEventType.adClicked,
      adNetwork: adNetwork,
      adUnitType: adUnitType,
      data: data,
    ));
  }

  void onAdShowedMethod(AdNetwork adNetwork, AdUnitType adUnitType, Object? data) {
    _onEventController.add(AdEvent(
      type: AdEventType.adShowed,
      adNetwork: adNetwork,
      adUnitType: adUnitType,
      data: data,
    ));
  }

  void onAdFailedToLoadMethod(
      AdNetwork adNetwork, AdUnitType adUnitType, Object? data, String errorMessage) {
    _onEventController.add(AdEvent(
      type: AdEventType.adFailedToLoad,
      adNetwork: adNetwork,
      adUnitType: adUnitType,
      data: data,
      error: errorMessage,
    ));
  }

  void onAdFailedToShowMethod(
      AdNetwork adNetwork, AdUnitType adUnitType, Object? data, String errorMessage) {
    _onEventController.add(AdEvent(
      type: AdEventType.adFailedToShow,
      adNetwork: adNetwork,
      adUnitType: adUnitType,
      data: data,
      error: errorMessage,
    ));
  }

  void onAdDismissedMethod(AdNetwork adNetwork, AdUnitType adUnitType, Object? data) {
    _onEventController.add(AdEvent(
      type: AdEventType.adDismissed,
      adNetwork: adNetwork,
      adUnitType: adUnitType,
      data: data,
    ));
  }

  void onEarnedRewardMethod(
      AdNetwork adNetwork, AdUnitType adUnitType, String? rewardType, num? rewardAmount) {
    _onEventController.add(AdEvent(
      type: AdEventType.earnedReward,
      adNetwork: adNetwork,
      adUnitType: adUnitType,
      data: {'rewardType': rewardType, 'rewardAmount': rewardAmount},
    ));
  }

  void onPaidEventMethod({
    required AdNetwork adNetwork,
    required AdUnitType adUnitType,
    required double revenue,
    required String currencyCode,
    String? network,
    String? unit,
    String? placement,
  }) {
    _onEventController.add(AdEvent(
      type: AdEventType.onPaidEvent,
      adNetwork: adNetwork,
      adUnitType: adUnitType,
      data: {
        'revenue': revenue,
        'currencyCode': currencyCode,
        'network': network,
        'unit': unit,
        'placement': placement,
      },
    ));
  }
}
