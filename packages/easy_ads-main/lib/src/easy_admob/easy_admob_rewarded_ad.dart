import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../easy_ad_base.dart';
import '../easy_ads.dart';
import '../enums/ad_network.dart';
import '../enums/ad_unit_type.dart';

class EasyAdmobRewardedAd extends EasyAdBase {
  final AdRequest adRequest;

  EasyAdmobRewardedAd({
    required super.adUnitId,
    required this.adRequest,
    super.onAdLoaded,
    super.onAdShowed,
    super.onAdClicked,
    super.onAdFailedToLoad,
    super.onAdFailedToShow,
    super.onAdDismissed,
    super.onEarnedReward,
    super.onPaidEvent,
  });

  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;
  bool _isAdLoading = false;
  bool _isAdLoadedFailed = false;

  @override
  AdNetwork get adNetwork => AdNetwork.admob;

  @override
  AdUnitType get adUnitType => AdUnitType.rewarded;

  @override
  bool get isAdLoaded => _isAdLoaded;

  @override
  bool get isAdLoading => _isAdLoading;

  @override
  bool get isAdLoadedFailed => _isAdLoadedFailed;

  @override
  void dispose() {
    _isAdLoaded = false;
    _isAdLoading = false;
    _isAdLoadedFailed = false;
    _rewardedAd?.dispose();
    _rewardedAd = null;
  }

  @override
  Future<void> load() async {
    if (_isAdLoaded) return;
    _isAdLoading = true;
    await RewardedAd.load(
      adUnitId: adUnitId,
      request: adRequest,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _rewardedAd?.onPaidEvent = (ad, revenue, type, currencyCode) {
            EasyAds.instance.onPaidEventMethod(
              adNetwork: adNetwork,
              adUnitType: adUnitType,
              revenue: revenue / 1000000,
              currencyCode: currencyCode,
              network: ad.responseInfo?.loadedAdapterResponseInfo?.adSourceName,
            );
            onPaidEvent?.call(
              adNetwork: adNetwork,
              adUnitType: adUnitType,
              revenue: revenue / 1000000,
              currencyCode: currencyCode,
              network: ad.responseInfo?.loadedAdapterResponseInfo?.adSourceName,
            );
          };
          _isAdLoaded = true;
          _isAdLoadedFailed = false;
          _isAdLoading = false;
          EasyAds.instance.onAdLoadedMethod(adNetwork, adUnitType, ad);
          onAdLoaded?.call(adNetwork, adUnitType, ad);
        },
        onAdFailedToLoad: (LoadAdError error) {
          _rewardedAd = null;
          _isAdLoaded = false;
          _isAdLoadedFailed = true;
          _isAdLoading = false;
          EasyAds.instance.onAdFailedToLoadMethod(
              adNetwork, adUnitType, error, error.toString());
          onAdFailedToLoad?.call(
              adNetwork, adUnitType, error, error.toString());
        },
      ),
    );
  }

  @override
  dynamic show({
    double? height,
    Color? color,
    BorderRadiusGeometry? borderRadius,
    BoxBorder? border,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    final ad = _rewardedAd;
    if (ad == null) return;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {
        EasyAds.instance.onAdShowedMethod(adNetwork, adUnitType, ad);
        onAdShowed?.call(adNetwork, adUnitType, ad);
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        EasyAds.instance.onAdDismissedMethod(adNetwork, adUnitType, ad);
        onAdDismissed?.call(adNetwork, adUnitType, ad);

        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        EasyAds.instance.onAdFailedToShowMethod(
            adNetwork, adUnitType, ad, error.toString());
        onAdFailedToShow?.call(adNetwork, adUnitType, ad, error.toString());

        ad.dispose();
      },
      onAdClicked: (ad) {
        EasyAds.instance.onAdClickedMethod(adNetwork, adUnitType, ad);
        onAdClicked?.call(adNetwork, adUnitType, ad);
      },
    );

    ad.setImmersiveMode(true);
    ad.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        EasyAds.instance.onEarnedRewardMethod(
            adNetwork, adUnitType, reward.type, reward.amount);
        onEarnedReward?.call(adNetwork, adUnitType, reward.type, reward.amount);
      },
    );
    _rewardedAd = null;
    _isAdLoaded = false;
  }
}
