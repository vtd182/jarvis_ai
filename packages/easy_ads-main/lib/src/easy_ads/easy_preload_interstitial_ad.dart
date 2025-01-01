import '../../channel/easy_ad_platform_interface.dart';
import '../../channel/loading_channel.dart';
import '../../easy_ads_flutter.dart';

class EasyPreloadInterstitialController {
  final AdNetwork adNetwork;
  EasyAdBase? interstitialAd;
  final String adId;
  final bool config;
  int loadTimesFailed = 0;
  final int limitLoad;
  final bool autoReloadOnFinish;

  EasyPreloadInterstitialController({
    this.adNetwork = AdNetwork.admob,
    required this.adId,
    required this.config,
    this.limitLoad = 3,
    required this.autoReloadOnFinish,
  });

  void dispose() {
    interstitialAd?.dispose();
    interstitialAd = null;
    loadTimesFailed = 0;
  }

  Future<void> load() async {
    if (interstitialAd != null) return;
    if (!EasyAds.instance.isEnabled || !config) return;
    if (EasyAds.instance.isDeviceOffline) return;
    if (!ConsentManager.ins.canRequestAds) return;

    interstitialAd = EasyAds.instance.createInterstitial(
      adNetwork: adNetwork,
      adId: adId,
      onAdFailedToLoad: (adNetwork, adUnitType, data, errorMessage) {
        interstitialAd = null;
        if (loadTimesFailed < limitLoad) {
          loadTimesFailed++;
          Future.delayed(
            const Duration(milliseconds: 500),
            () => load(),
          );
        }
      },
      onAdLoaded: (adNetwork, adUnitType, data) {
        loadTimesFailed = 0;
      },
    );
    if (interstitialAd != null) {
      interstitialAd!.load();
    }
  }

  Future<void> show({
    Function()? onDisabled,
    EasyAdCallback? onAdLoaded,
    EasyAdCallback? onAdShowed,
    EasyAdCallback? onAdClicked,
    EasyAdFailedCallback? onAdFailedToLoad,
    EasyAdFailedCallback? onAdFailedToShow,
    EasyAdCallback? onAdDismissed,
    EasyAdOnPaidEvent? onPaidEvent,
    int timeoutInSeconds = 30,
  }) async {
    if (interstitialAd == null || !interstitialAd!.isAdLoaded) {
      EasyAds.instance.showInterstitialAd(
        adId: adId,
        config: config,
        timeoutInSeconds: timeoutInSeconds,
        onPaidEvent: onPaidEvent,
        onAdLoaded: onAdLoaded,
        onAdShowed: onAdShowed,
        onAdClicked: onAdClicked,
        onDisabled: () {
          onDisabled?.call();
          dispose();
          if (autoReloadOnFinish) {
            load();
          }
        },
        onAdDismissed: (adNetwork, adUnitType, data) {
          onAdDismissed?.call(adNetwork, adUnitType, data);
          dispose();
          if (autoReloadOnFinish) {
            load();
          }
        },
        onAdFailedToLoad: (adNetwork, adUnitType, data, errorMessage) {
          onAdFailedToLoad?.call(adNetwork, adUnitType, data, errorMessage);
          dispose();
          if (autoReloadOnFinish) {
            load();
          }
        },
        onAdFailedToShow: (adNetwork, adUnitType, data, errorMessage) {
          onAdFailedToShow?.call(adNetwork, adUnitType, data, errorMessage);
          dispose();
          if (autoReloadOnFinish) {
            load();
          }
        },
      );
      return;
    }

    // override callback
    interstitialAd!.updateListener(
      onAdDismissed: (adNetwork, adUnitType, data) {
        onAdDismissed?.call(adNetwork, adUnitType, data);
        EasyAds.instance.setFullscreenAdShowing(false);
        dispose();
        if (autoReloadOnFinish) {
          load();
        }
      },
      onAdFailedToShow: (adNetwork, adUnitType, data, errorMessage) {
        LoadingChannel.closeAd();
        onAdFailedToShow?.call(adNetwork, adUnitType, data, errorMessage);
        EasyAds.instance.setFullscreenAdShowing(false);
        dispose();
        if (autoReloadOnFinish) {
          load();
        }
      },
      onAdShowed: (adNetwork, adUnitType, data) {
        Future.delayed(const Duration(seconds: 1), () {
          LoadingChannel.closeAd();
        });
        onAdShowed?.call(adNetwork, adUnitType, data);
      },
      onPaidEvent: onPaidEvent,
    );
    LoadingChannel.setMethodCallHandler(interstitialAd!.show);
    EasyAds.instance.setFullscreenAdShowing(true);
    EasyAdPlatform.instance.showLoadingAd(EasyAds.instance.getPrimaryColor());

    Future.delayed(const Duration(seconds: 1), () {
      onAdLoaded?.call(adNetwork, AdUnitType.interstitial, null);
      LoadingChannel.handleShowAd();
    });
  }
}
