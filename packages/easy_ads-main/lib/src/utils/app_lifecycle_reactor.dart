// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';

import '../../channel/easy_ad_platform_interface.dart';
import '../../channel/loading_channel.dart';
import '../../easy_ads_flutter.dart';

/// Listens for app foreground events and shows app open ads.
class AppLifecycleReactor {
  final GlobalKey<NavigatorState> navigatorKey;
  final String? adId;
  final AdNetwork adNetwork;
  final bool preloadAdResume;
  EasyAdBase? adResume;

  bool _onSplashScreen = true;
  bool _isExcludeScreen = false;
  bool config;

  AppLifecycleReactor({
    required this.navigatorKey,
    required this.adId,
    this.config = true,
    required this.adNetwork,
    required this.preloadAdResume,
  });

  Future<void> preloadAd() async {
    if (!preloadAdResume ||
        !config ||
        !EasyAds.instance.isEnabled ||
        EasyAds.instance.isDeviceOffline ||
        !ConsentManager.ins.canRequestAds) return;

    final String id =
        EasyAds.instance.isDevMode ? TestAdsId.admobOpenResume : adId!;
    if (id.isNotEmpty != true) return;
    adResume = EasyAds.instance.createAppOpenAd(
      adNetwork: adNetwork,
      adId: id,
      onAdFailedToLoad: (adNetwork, adUnitType, data, errorMessage) {
        adResume = null;
        EasyAds.instance.setFullscreenAdShowing(false);
      },
      onAdFailedToShow: (adNetwork, adUnitType, data, errorMessage) {
        LoadingChannel.closeAd();
        adResume = null;
        preloadAd();
        EasyAds.instance.setFullscreenAdShowing(false);
      },
      onAdLoaded: (adNetwork, adUnitType, data) {},
      onAdShowed: (adNetwork, adUnitType, data) {
        Future.delayed(const Duration(seconds: 1), () {
          LoadingChannel.closeAd();
        });
      },
      onAdDismissed: (adNetwork, adUnitType, data) {
        adResume = null;
        preloadAd();
        EasyAds.instance.setFullscreenAdShowing(false);
      },
    );
    adResume!.load();
  }

  void listenToAppStateChanges() {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream.forEach(_onAppStateChanged);
  }

  void setOnSplashScreen(bool value) {
    _onSplashScreen = value;
  }

  void setIsExcludeScreen(bool value) {
    _isExcludeScreen = value;
  }

  Future<void> _onAppStateChanged(AppState appState) async {
    if (_onSplashScreen) return;
    if (!config) return;

    if (navigatorKey.currentContext == null) return;

    // Show AppOpenAd when back to foreground but do not show on excluded screens
    if (appState == AppState.foreground) {
      await EasyAds.instance.initConnectivity();
      if (!_isExcludeScreen) {
        if (EasyAds.instance.isFullscreenAdShowing) {
          return;
        }
        if (!EasyAds.instance.isEnabled) {
          return;
        }
        if (!ConsentManager.ins.canRequestAds) {
          return;
        }
        if (EasyAds.instance.isDeviceOffline) {
          return;
        }

        final String id =
            EasyAds.instance.isDevMode ? TestAdsId.admobOpenResume : adId!;
        if (id.isNotEmpty != true) return;
        if (preloadAdResume && adResume != null && adResume!.isAdLoaded) {
          LoadingChannel.setMethodCallHandler(adResume!.show);
          EasyAds.instance.setFullscreenAdShowing(true);
          EasyAdPlatform.instance
              .showLoadingAd(EasyAds.instance.getPrimaryColor());
          Future.delayed(
            const Duration(seconds: 1),
            LoadingChannel.handleShowAd,
          );
        } else {
          EasyAds.instance.showAppOpen(
            adId: id,
            config: true,
          );
        }

        // navigatorKey.currentState?.push(
        //   EasyAppOpenAd.getRoute(
        //     context: navigatorKey.currentContext!,
        //     adId: id,
        //     adNetwork: adNetwork,
        //   ),
        // );
      } else {
        _isExcludeScreen = false;
      }
    } else {
      EasyAds.instance.cancelConnectivityOnBackground();
    }
  }
}
