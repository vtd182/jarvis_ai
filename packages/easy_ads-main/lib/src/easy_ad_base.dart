import 'package:flutter/material.dart';

import 'enums/ad_network.dart';
import 'enums/ad_unit_type.dart';

abstract class EasyAdBase {
  final String adUnitId;
  EasyAdCallback? onAdLoaded;
  EasyAdCallback? onAdShowed;
  EasyAdCallback? onAdClicked;
  EasyAdFailedCallback? onAdFailedToLoad;
  EasyAdFailedCallback? onAdFailedToShow;
  EasyAdCallback? onAdDismissed;
  EasyAdEarnedReward? onEarnedReward;
  EasyAdOnPaidEvent? onPaidEvent;
  EasyAdCallback? onBannerAdReadyForSetState;

  /// This will be called for initialization when we don't have to wait for the initialization
  EasyAdBase({
    required this.adUnitId,
    this.onAdLoaded,
    this.onAdShowed,
    this.onAdClicked,
    this.onAdFailedToLoad,
    this.onAdFailedToShow,
    this.onAdDismissed,
    this.onEarnedReward,
    this.onPaidEvent,
    this.onBannerAdReadyForSetState,
  });

  void updateListener({
    EasyAdCallback? onAdLoaded,
    EasyAdCallback? onAdShowed,
    EasyAdCallback? onAdClicked,
    EasyAdFailedCallback? onAdFailedToLoad,
    EasyAdFailedCallback? onAdFailedToShow,
    EasyAdCallback? onAdDismissed,
    EasyAdEarnedReward? onEarnedReward,
    EasyAdOnPaidEvent? onPaidEvent,
    EasyAdCallback? onBannerAdReadyForSetState,
  }) {
    this.onAdLoaded = onAdLoaded;
    this.onAdShowed = onAdShowed;
    this.onAdClicked = onAdClicked;
    this.onAdFailedToLoad = onAdFailedToLoad;
    this.onAdFailedToShow = onAdFailedToShow;
    this.onAdDismissed = onAdDismissed;
    this.onEarnedReward = onEarnedReward;
    this.onPaidEvent = onPaidEvent;
    this.onBannerAdReadyForSetState = onBannerAdReadyForSetState;
  }

  AdNetwork get adNetwork;
  AdUnitType get adUnitType;
  bool get isAdLoaded;
  bool get isAdLoading;
  bool get isAdLoadedFailed;

  void dispose();

  /// This will load ad, It will only load the ad if isAdLoaded is false
  Future<void> load();

  dynamic show({
    double? height,
    Color? color,
    BorderRadiusGeometry? borderRadius,
    BoxBorder? border,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  });
}

typedef EasyAdNetworkInitialized = void Function(
  AdNetwork adNetwork,
  bool isInitialized,
  Object? data,
);
typedef EasyAdFailedCallback = void Function(
  AdNetwork adNetwork,
  AdUnitType adUnitType,
  Object? data,
  String errorMessage,
);
typedef EasyAdCallback = void Function(
  AdNetwork adNetwork,
  AdUnitType adUnitType,
  Object? data,
);
typedef EasyAdEarnedReward = void Function(
  AdNetwork adNetwork,
  AdUnitType adUnitType,
  String? rewardType,
  num? rewardAmount,
);

typedef EasyAdOnPaidEvent = void Function({
  required AdNetwork adNetwork,
  required AdUnitType adUnitType,
  required double revenue,
  required String currencyCode,
  String? network,
  String? unit,
  String? placement,
});
