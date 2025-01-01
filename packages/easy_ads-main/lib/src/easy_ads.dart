// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:ui' as ui;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_ads_flutter/channel/easy_ad_platform_interface.dart';
import 'package:easy_ads_flutter/src/utils/easy_logger.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../channel/loading_channel.dart';
import '../easy_ads_flutter.dart';
import 'easy_admob/easy_admob_interstitial_ad.dart';
import 'easy_admob/easy_admob_rewarded_ad.dart';
import 'easy_ads/easy_splash_ad_with_2_inter.dart';
import 'easy_ads/easy_splash_ad_with_3_inter.dart';
import 'easy_ads/easy_splash_ad_with_interstitial_and_app_open.dart';

part 'utils/easy_ads_extension.dart';

class EasyAds {
  EasyAds._easyAds();

  static final EasyAds instance = EasyAds._easyAds();
  AppLifecycleReactor? appLifecycleReactor;
  GlobalKey<NavigatorState>? navigatorKey;

  /// Google admob's ad request
  AdRequest _adRequest = const AdRequest();
  late final IAdIdManager adIdManager;

  /// True value when there is exist an Ad and false otherwise.
  bool _isFullscreenAdShowing = false;

  void setFullscreenAdShowing(bool value) => _isFullscreenAdShowing = value;

  bool get isFullscreenAdShowing => _isFullscreenAdShowing;

  /// Enable or disable all ads
  bool _isEnabled = true;

  void enableAd(bool value) => _isEnabled = value;

  bool get isEnabled => _isEnabled;

  // final _eventController = EasyEventController();
  // Stream<AdEvent> get onEvent => _eventController.onEvent;

  Stream<AdEvent> get onEvent => _onEventController.stream;
  final _onEventController = StreamController<AdEvent>.broadcast();

  /// Preload interstitial normal
  EasyAdBase? interNormal;
  int loadTimesFailedInterNormal = 0;

  /// Preload interstitial priority
  EasyAdBase? interPriority;
  int loadTimesFailedInterPriority = 0;

  /// [_logger] is used to show Ad logs in the console
  final EasyLogger _logger = EasyLogger();
  AdSize? admobAdSize;

  RequestConfiguration? admobConfiguration;

  bool _isDevMode = true;

  bool get isDevMode => _isDevMode;

  bool _isAdmobInitialized = false;

  Future<void> initAdmob() async {
    if (_isAdmobInitialized) {
      return;
    }

    if (adIdManager.admobAdIds?.appId.isNotEmpty != true) {
      return;
    }
    if (EasyAds.instance.admobConfiguration != null) {
      await MobileAds.instance.updateRequestConfiguration(admobConfiguration!);
    }

    final initializationStatus = await MobileAds.instance.initialize();

    initializationStatus.adapterStatuses.forEach((key, value) {
      _logger.logInfo('Adapter status for $key: ${value.description} | ${value.state}');
    });
    _isAdmobInitialized = true;
    fireNetworkInitializedEvent(
        AdNetwork.admob,
        initializationStatus.adapterStatuses.values.firstOrNull?.state ==
            AdapterInitializationState.ready);
  }

  Future<void> initAdNetwork() async {
    await initAdmob();
    appLifecycleReactor?.preloadAd();
  }

  void resetUmp() {
    ConsentInformation.instance.reset();
  }

  /// Initializes the Google Mobile Ads SDK.
  ///
  /// Call this method as early as possible after the app launches
  /// [adMobAdRequest] will be used in all the admob requests. By default empty request will be used if nothing passed here.
  Future<void> initialize(
    IAdIdManager manager, {
    AdRequest? adMobAdRequest,
    RequestConfiguration? admobConfiguration,
    bool enableLogger = true,
    required bool isDevMode,
    bool debugUmp = false,
    GlobalKey<NavigatorState>? navigatorKey,
    String? adResumeId,
    required bool adResumeConfig,
    AdNetwork adResumeNetwork = AdNetwork.admob,
    bool preloadAdResume = false,

    ///init mediation callback
    Future<dynamic> Function(bool canRequestAds)? initMediationCallback,
    required Function(bool canRequestAds) onInitialized,
  }) async {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    if (enableLogger) _logger.enable(enableLogger);

    _isDevMode = isDevMode;

    adIdManager = manager;
    if (adMobAdRequest != null) {
      _adRequest = adMobAdRequest;
    }

    /// Handle UMP
    ConsentManager.ins.debugUmp = debugUmp;
    ConsentManager.ins.testIdentifiers = admobConfiguration?.testDeviceIds;
    ConsentManager.ins.initMediation = initMediationCallback;

    if (debugUmp) {
      resetUmp();
    }
    await initConnectivity();
    ConsentManager.ins
        .handleRequestUmp(onPostExecute: () => onInitialized(ConsentManager.ins.canRequestAds));

    if (manager.admobAdIds?.appId != null) {
      this.admobConfiguration = admobConfiguration;
      if (navigatorKey?.currentContext != null) {
        admobAdSize = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.sizeOf(navigatorKey!.currentContext!).width.toInt());
      }
    }

    if (navigatorKey != null) {
      this.navigatorKey = navigatorKey;
      appLifecycleReactor = AppLifecycleReactor(
        navigatorKey: navigatorKey,
        adId: adResumeId,
        config: adResumeConfig,
        adNetwork: adResumeNetwork,
        preloadAdResume: preloadAdResume,
      );
      appLifecycleReactor!.listenToAppStateChanges();
    }
  }

  /// Returns [EasyAdBase] if ad is created successfully. It assumes that you have already assigned banner id in Ad Id Manager
  ///
  /// if [adNetwork] is provided, only that network's ad would be created. For now, only unity and admob banner is supported
  /// [admobAdSize] is used to provide ad banner size
  EasyAdBase? createBanner({
    required AdNetwork adNetwork,
    required String adId,
    required EasyAdsBannerType type,
    EasyAdCallback? onAdLoaded,
    EasyAdCallback? onAdShowed,
    EasyAdCallback? onAdClicked,
    EasyAdFailedCallback? onAdFailedToLoad,
    EasyAdFailedCallback? onAdFailedToShow,
    EasyAdCallback? onAdDismissed,
    EasyAdEarnedReward? onEarnedReward,
    EasyAdOnPaidEvent? onPaidEvent,
  }) {
    EasyAdBase? ad;
    if (adNetwork == AdNetwork.admob) {
      /// Get ad request
      AdRequest adRequest = _adRequest;
      if (type == EasyAdsBannerType.collapsible_bottom) {
        adRequest = AdRequest(
          httpTimeoutMillis: _adRequest.httpTimeoutMillis,
          contentUrl: _adRequest.contentUrl,
          keywords: _adRequest.keywords,
          mediationExtras: _adRequest.mediationExtras,
          neighboringContentUrls: _adRequest.neighboringContentUrls,
          nonPersonalizedAds: _adRequest.nonPersonalizedAds,
          extras: {'collapsible': 'bottom'},
        );
      } else if (type == EasyAdsBannerType.collapsible_top) {
        adRequest = AdRequest(
          httpTimeoutMillis: _adRequest.httpTimeoutMillis,
          contentUrl: _adRequest.contentUrl,
          keywords: _adRequest.keywords,
          mediationExtras: _adRequest.mediationExtras,
          neighboringContentUrls: _adRequest.neighboringContentUrls,
          nonPersonalizedAds: _adRequest.nonPersonalizedAds,
          extras: {'collapsible': 'top'},
        );
      }

      AdSize adSize = getAdmobAdSize(
        type: type,
      );

      final String id = EasyAds.instance.isDevMode
          ? (type == EasyAdsBannerType.collapsible_bottom ||
                  type == EasyAdsBannerType.collapsible_top)
              ? TestAdsId.admobBannerCollapseId
              : TestAdsId.admobBannerId
          : adId;

      ad = EasyAdmobBannerAd(
        adUnitId: id,
        adSize: adSize,
        adRequest: adRequest,
        onAdLoaded: onAdLoaded,
        onAdShowed: onAdShowed,
        onAdClicked: onAdClicked,
        onAdFailedToLoad: onAdFailedToLoad,
        onAdFailedToShow: onAdFailedToShow,
        onAdDismissed: onAdDismissed,
        onEarnedReward: onEarnedReward,
        onPaidEvent: onPaidEvent,
      );
    }
    return ad;
  }

  EasyAdBase? createNative({
    required AdNetwork adNetwork,
    required String factoryId,
    required String adId,
    EasyAdCallback? onAdLoaded,
    EasyAdCallback? onAdShowed,
    EasyAdCallback? onAdClicked,
    EasyAdFailedCallback? onAdFailedToLoad,
    EasyAdFailedCallback? onAdFailedToShow,
    EasyAdCallback? onAdDismissed,
    EasyAdEarnedReward? onEarnedReward,
    EasyAdOnPaidEvent? onPaidEvent,
  }) {
    EasyAdBase? ad;
    switch (adNetwork) {
      default:
        final String id = EasyAds.instance.isDevMode ? TestAdsId.admobNativeId : adId;
        ad = EasyAdmobNativeAd(
          adUnitId: id,
          factoryId: factoryId,
          adRequest: _adRequest,
          onAdLoaded: onAdLoaded,
          onAdShowed: onAdShowed,
          onAdClicked: onAdClicked,
          onAdFailedToLoad: onAdFailedToLoad,
          onAdFailedToShow: onAdFailedToShow,
          onAdDismissed: onAdDismissed,
          onEarnedReward: onEarnedReward,
          onPaidEvent: onPaidEvent,
        );
        break;
    }

    return ad;
  }

  EasyAdBase? createPreloadNative({
    required AdNetwork adNetwork,
    required EasyAdsPlacementType type,
    required String adId,
    EasyAdCallback? onAdLoaded,
    EasyAdCallback? onAdShowed,
    EasyAdCallback? onAdClicked,
    EasyAdFailedCallback? onAdFailedToLoad,
    EasyAdFailedCallback? onAdFailedToShow,
    EasyAdCallback? onAdDismissed,
    EasyAdEarnedReward? onEarnedReward,
    EasyAdOnPaidEvent? onPaidEvent,
  }) {
    EasyAdBase? ad;
    switch (adNetwork) {
      default:
        final String id = EasyAds.instance.isDevMode ? TestAdsId.admobNativeId : adId;
        ad = EasyAdmobPreloadNativeAd(
          adUnitId: id,
          type: type,
          adRequest: _adRequest,
          onAdLoaded: onAdLoaded,
          onAdShowed: onAdShowed,
          onAdClicked: onAdClicked,
          onAdFailedToLoad: onAdFailedToLoad,
          onAdFailedToShow: onAdFailedToShow,
          onAdDismissed: onAdDismissed,
          onEarnedReward: onEarnedReward,
          onPaidEvent: onPaidEvent,
        );
        break;
    }

    return ad;
  }

  EasyAdBase? createInterstitial({
    required AdNetwork adNetwork,
    required String adId,
    EasyAdCallback? onAdLoaded,
    EasyAdCallback? onAdShowed,
    EasyAdCallback? onAdClicked,
    EasyAdFailedCallback? onAdFailedToLoad,
    EasyAdFailedCallback? onAdFailedToShow,
    EasyAdCallback? onAdDismissed,
    EasyAdEarnedReward? onEarnedReward,
    EasyAdOnPaidEvent? onPaidEvent,
  }) {
    EasyAdBase? ad;
    switch (adNetwork) {
      default:
        final String id = EasyAds.instance.isDevMode ? TestAdsId.admobInterstitialId : adId;
        ad = EasyAdmobInterstitialAd(
          adUnitId: id,
          adRequest: _adRequest,
          onAdLoaded: onAdLoaded,
          onAdShowed: onAdShowed,
          onAdClicked: onAdClicked,
          onAdFailedToLoad: onAdFailedToLoad,
          onAdFailedToShow: onAdFailedToShow,
          onAdDismissed: onAdDismissed,
          onEarnedReward: onEarnedReward,
          onPaidEvent: onPaidEvent,
        );
        break;
    }
    return ad;
  }

  EasyAdBase? createReward({
    required AdNetwork adNetwork,
    required String adId,
    EasyAdCallback? onAdLoaded,
    EasyAdCallback? onAdShowed,
    EasyAdCallback? onAdClicked,
    EasyAdFailedCallback? onAdFailedToLoad,
    EasyAdFailedCallback? onAdFailedToShow,
    EasyAdCallback? onAdDismissed,
    EasyAdEarnedReward? onEarnedReward,
    EasyAdOnPaidEvent? onPaidEvent,
  }) {
    EasyAdBase? ad;
    switch (adNetwork) {
      default:
        final String id = EasyAds.instance.isDevMode ? TestAdsId.admobRewardId : adId;
        ad = EasyAdmobRewardedAd(
          adUnitId: id,
          adRequest: _adRequest,
          onAdLoaded: onAdLoaded,
          onAdShowed: onAdShowed,
          onAdClicked: onAdClicked,
          onAdFailedToLoad: onAdFailedToLoad,
          onAdFailedToShow: onAdFailedToShow,
          onAdDismissed: onAdDismissed,
          onEarnedReward: onEarnedReward,
          onPaidEvent: onPaidEvent,
        );
        break;
    }

    return ad;
  }

  EasyAdBase? createAppOpenAd({
    required AdNetwork adNetwork,
    required String adId,
    EasyAdCallback? onAdLoaded,
    EasyAdCallback? onAdShowed,
    EasyAdCallback? onAdClicked,
    EasyAdFailedCallback? onAdFailedToLoad,
    EasyAdFailedCallback? onAdFailedToShow,
    EasyAdCallback? onAdDismissed,
    EasyAdEarnedReward? onEarnedReward,
    EasyAdOnPaidEvent? onPaidEvent,
  }) {
    EasyAdBase? ad;
    switch (adNetwork) {
      default:
        String id = EasyAds.instance.isDevMode ? TestAdsId.admobOpenResume : adId;
        ad = EasyAdmobAppOpenAd(
          adUnitId: id,
          adRequest: _adRequest,
          onAdLoaded: onAdLoaded,
          onAdShowed: onAdShowed,
          onAdClicked: onAdClicked,
          onAdFailedToLoad: onAdFailedToLoad,
          onAdFailedToShow: onAdFailedToShow,
          onAdDismissed: onAdDismissed,
          onEarnedReward: onEarnedReward,
          onPaidEvent: onPaidEvent,
        );
        break;
    }

    return ad;
  }

  Future<void> showAppOpen({
    AdNetwork adNetwork = AdNetwork.admob,
    required String adId,
    Function()? onDisabled,
    required bool config,
    EasyAdCallback? onAdLoaded,
    EasyAdCallback? onAdShowed,
    EasyAdCallback? onAdClicked,
    EasyAdFailedCallback? onAdFailedToLoad,
    EasyAdFailedCallback? onAdFailedToShow,
    EasyAdCallback? onAdDismissed,
    EasyAdOnPaidEvent? onPaidEvent,
  }) async {
    if (!isEnabled || !config) {
      onDisabled?.call();
      return;
    }
    if (_isFullscreenAdShowing) {
      onDisabled?.call();
      return;
    }
    if (isDeviceOffline) {
      onDisabled?.call();
      return;
    }
    if (!ConsentManager.ins.canRequestAds) {
      onDisabled?.call();
      return;
    }

    final appOpen = createAppOpenAd(
      adNetwork: adNetwork,
      adId: adId,
      onAdClicked: onAdClicked,
      onAdDismissed: (adNetwork, adUnitType, data) {
        onAdDismissed?.call(adNetwork, adUnitType, data);
        EasyAds.instance.setFullscreenAdShowing(false);
      },
      onAdFailedToLoad: (adNetwork, adUnitType, data, errorMessage) {
        LoadingChannel.closeAd();
        onAdFailedToLoad?.call(adNetwork, adUnitType, data, errorMessage);
        EasyAds.instance.setFullscreenAdShowing(false);
      },
      onAdFailedToShow: (adNetwork, adUnitType, data, errorMessage) {
        LoadingChannel.closeAd();
        onAdFailedToShow?.call(adNetwork, adUnitType, data, errorMessage);
        EasyAds.instance.setFullscreenAdShowing(false);
      },
      onAdLoaded: (adNetwork, adUnitType, data) {
        onAdLoaded?.call(adNetwork, adUnitType, data);
        LoadingChannel.handleShowAd();
      },
      onAdShowed: (adNetwork, adUnitType, data) {
        Future.delayed(const Duration(seconds: 1), () {
          LoadingChannel.closeAd();
        });
        onAdShowed?.call(adNetwork, adUnitType, data);
      },
      onPaidEvent: onPaidEvent,
    );

    if (appOpen == null) {
      return;
    }

    LoadingChannel.setMethodCallHandler(appOpen.show);
    EasyAds.instance.setFullscreenAdShowing(true);

    EasyAdPlatform.instance.showLoadingAd(getPrimaryColor());
    appOpen.load();
  }

  Timer? _timer;

  Future<void> showInterstitialAd({
    AdNetwork adNetwork = AdNetwork.admob,
    required String adId,
    Function()? onDisabled,
    required bool config,
    EasyAdCallback? onAdLoaded,
    EasyAdCallback? onAdShowed,
    EasyAdCallback? onAdClicked,
    EasyAdFailedCallback? onAdFailedToLoad,
    EasyAdFailedCallback? onAdFailedToShow,
    EasyAdCallback? onAdDismissed,
    EasyAdOnPaidEvent? onPaidEvent,
    int timeoutInSeconds = 30,
  }) async {
    if (!isEnabled || !config) {
      onDisabled?.call();
      return;
    }
    if (_isFullscreenAdShowing) {
      onDisabled?.call();
      return;
    }
    if (isDeviceOffline) {
      onDisabled?.call();
      return;
    }
    if (!ConsentManager.ins.canRequestAds) {
      onDisabled?.call();
      return;
    }
    final interstitialAd = createInterstitial(
      adNetwork: adNetwork,
      adId: adId,
      onAdClicked: onAdClicked,
      onAdDismissed: (adNetwork, adUnitType, data) {
        onAdDismissed?.call(adNetwork, adUnitType, data);
        EasyAds.instance.setFullscreenAdShowing(false);
      },
      onAdFailedToLoad: (adNetwork, adUnitType, data, errorMessage) {
        LoadingChannel.closeAd();
        onAdFailedToLoad?.call(adNetwork, adUnitType, data, errorMessage);
        EasyAds.instance.setFullscreenAdShowing(false);
      },
      onAdFailedToShow: (adNetwork, adUnitType, data, errorMessage) {
        LoadingChannel.closeAd();
        onAdFailedToShow?.call(adNetwork, adUnitType, data, errorMessage);
        EasyAds.instance.setFullscreenAdShowing(false);
      },
      onAdLoaded: (adNetwork, adUnitType, data) {
        if (_timer != null) {
          onAdLoaded?.call(adNetwork, adUnitType, data);
          LoadingChannel.handleShowAd();
          _timer!.cancel();
          _timer = null;
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
    if (interstitialAd == null) {
      onDisabled?.call();
      return;
    }

    LoadingChannel.setMethodCallHandler(interstitialAd.show);
    EasyAds.instance.setFullscreenAdShowing(true);

    EasyAdPlatform.instance.showLoadingAd(getPrimaryColor());
    interstitialAd.load();
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    _timer = Timer.periodic(
      Duration(seconds: timeoutInSeconds),
      (timer) {
        if (_timer != null) {
          _timer!.cancel();
          _timer = null;
        }
        interstitialAd.dispose();
        LoadingChannel.closeAd();
        onAdFailedToLoad?.call(adNetwork, AdUnitType.interstitial, null, 'Timeout');
        EasyAds.instance.setFullscreenAdShowing(false);
      },
    );
  }

  int getPrimaryColor() {
    if (navigatorKey?.currentContext == null) {
      return Colors.black.value;
    }

    return Theme.of(navigatorKey!.currentContext!).primaryColor.value;
  }

  Future<void> showRewardAd({
    AdNetwork adNetwork = AdNetwork.admob,
    required String adId,
    Function()? onDisabled,
    required bool config,
    EasyAdCallback? onAdLoaded,
    EasyAdCallback? onAdShowed,
    EasyAdCallback? onAdClicked,
    EasyAdFailedCallback? onAdFailedToLoad,
    EasyAdFailedCallback? onAdFailedToShow,
    EasyAdCallback? onAdDismissed,
    EasyAdEarnedReward? onEarnedReward,
    EasyAdOnPaidEvent? onPaidEvent,
  }) async {
    if (!isEnabled || !config) {
      onDisabled?.call();
      return;
    }
    if (_isFullscreenAdShowing) {
      onDisabled?.call();
      return;
    }
    if (isDeviceOffline) {
      onDisabled?.call();
      return;
    }
    if (!ConsentManager.ins.canRequestAds) {
      onDisabled?.call();
      return;
    }
    final rewardAd = createReward(
      adNetwork: adNetwork,
      adId: adId,
      onAdClicked: onAdClicked,
      onAdDismissed: (adNetwork, adUnitType, data) {
        onAdDismissed?.call(adNetwork, adUnitType, data);
        EasyAds.instance.setFullscreenAdShowing(false);
      },
      onAdFailedToLoad: (adNetwork, adUnitType, data, errorMessage) {
        LoadingChannel.closeAd();
        onAdFailedToLoad?.call(adNetwork, adUnitType, data, errorMessage);
        EasyAds.instance.setFullscreenAdShowing(false);
      },
      onAdFailedToShow: (adNetwork, adUnitType, data, errorMessage) {
        LoadingChannel.closeAd();
        onAdFailedToShow?.call(adNetwork, adUnitType, data, errorMessage);
        EasyAds.instance.setFullscreenAdShowing(false);
      },
      onAdLoaded: (adNetwork, adUnitType, data) {
        onAdLoaded?.call(adNetwork, adUnitType, data);
        LoadingChannel.handleShowAd();
      },
      onAdShowed: (adNetwork, adUnitType, data) {
        Future.delayed(const Duration(seconds: 1), () {
          LoadingChannel.closeAd();
        });
        onAdShowed?.call(adNetwork, adUnitType, data);
      },
      onPaidEvent: onPaidEvent,
      onEarnedReward: onEarnedReward,
    );
    if (rewardAd == null) {
      return;
    }

    LoadingChannel.setMethodCallHandler(rewardAd.show);
    EasyAds.instance.setFullscreenAdShowing(true);

    EasyAdPlatform.instance.showLoadingAd(getPrimaryColor());
    rewardAd.load();
  }

  Future<void> showSplashAdWith2Inter({
    AdNetwork adNetwork = AdNetwork.admob,
    required String interstitialSplashId,
    required String interstitialSplashHighId,
    required Function()? onDisabled,
    EasyAdCallback? onAdLoaded,
    EasyAdCallback? onAdShowed,
    EasyAdCallback? onAdClicked,
    EasyAdFailedCallback? onAdFailedToLoad,
    EasyAdFailedCallback? onAdFailedToShow,
    EasyAdCallback? onAdDismissed,
    EasyAdOnPaidEvent? onPaidEvent,
    required bool config,
    EasyAdCallback? onAdHighLoaded,
    EasyAdCallback? onAdHighShowed,
    EasyAdCallback? onAdHighClicked,
    EasyAdFailedCallback? onAdHighFailedToLoad,
    EasyAdFailedCallback? onAdHighFailedToShow,
    EasyAdCallback? onAdHighDismissed,
    EasyAdOnPaidEvent? onHighPaidEvent,
    required bool configHigh,
    Function(EasyAdsPlacementType type)? onShowed,
    Function(EasyAdsPlacementType type)? onDismissed,
    Function()? onFailedToLoad,
    Function(EasyAdsPlacementType type)? onFailedToShow,
    Function(EasyAdsPlacementType type)? onClicked,
  }) async {
    if (!isEnabled) {
      onDisabled?.call();
      return;
    }

    if (!config && !configHigh) {
      onDisabled?.call();
      return;
    }

    if (_isFullscreenAdShowing) {
      onDisabled?.call();
      return;
    }
    if (isDeviceOffline) {
      onDisabled?.call();
      return;
    }
    // ignore: use_build_context_synchronously
    navigatorKey?.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => EasySplashAdWith2Inter(
          adNetwork: adNetwork,
          interstitialSplashId: interstitialSplashId,
          interstitialSplashHighId: interstitialSplashHighId,
          onAdLoaded: onAdLoaded,
          onAdShowed: onAdShowed,
          onAdClicked: onAdClicked,
          onAdFailedToLoad: onAdFailedToLoad,
          onAdFailedToShow: onAdFailedToShow,
          onAdDismissed: onAdDismissed,
          onPaidEvent: onPaidEvent,
          config: config,
          onAdHighLoaded: onAdHighLoaded,
          onAdHighShowed: onAdHighShowed,
          onAdHighClicked: onAdHighClicked,
          onAdHighFailedToLoad: onAdHighFailedToLoad,
          onAdHighFailedToShow: onAdHighFailedToShow,
          onAdHighDismissed: onAdHighDismissed,
          onHighPaidEvent: onHighPaidEvent,
          configHigh: configHigh,
          onShowed: onShowed,
          onDismissed: onDismissed,
          onFailedToLoad: onFailedToLoad,
          onFailedToShow: onFailedToShow,
          onClicked: onClicked,
        ),
        fullscreenDialog: true,
      ),
      (route) => true,
    );
  }

  Future<void> showSplashAdWith3Inter({
    AdNetwork adNetwork = AdNetwork.admob,
    required String interstitialSplashId,
    required String interstitialSplashMediumId,
    required String interstitialSplashHighId,
    required Function()? onDisabled,
    EasyAdCallback? onAdLoaded,
    EasyAdCallback? onAdShowed,
    EasyAdCallback? onAdClicked,
    EasyAdFailedCallback? onAdFailedToLoad,
    EasyAdFailedCallback? onAdFailedToShow,
    EasyAdCallback? onAdDismissed,
    EasyAdOnPaidEvent? onPaidEvent,
    required bool config,
    EasyAdCallback? onAdMediumLoaded,
    EasyAdCallback? onAdMediumShowed,
    EasyAdCallback? onAdMediumClicked,
    EasyAdFailedCallback? onAdMediumFailedToLoad,
    EasyAdFailedCallback? onAdMediumFailedToShow,
    EasyAdCallback? onAdMediumDismissed,
    EasyAdOnPaidEvent? onMediumPaidEvent,
    required bool configMedium,
    EasyAdCallback? onAdHighLoaded,
    EasyAdCallback? onAdHighShowed,
    EasyAdCallback? onAdHighClicked,
    EasyAdFailedCallback? onAdHighFailedToLoad,
    EasyAdFailedCallback? onAdHighFailedToShow,
    EasyAdCallback? onAdHighDismissed,
    EasyAdOnPaidEvent? onHighPaidEvent,
    required bool configHigh,
    Function(EasyAdsPlacementType type)? onShowed,
    Function(EasyAdsPlacementType type)? onDismissed,
    Function()? onFailedToLoad,
    Function(EasyAdsPlacementType type)? onFailedToShow,
    Function(EasyAdsPlacementType type)? onClicked,
  }) async {
    if (!isEnabled) {
      onDisabled?.call();
      return;
    }
    if (!config && !configMedium && !configHigh) {
      onDisabled?.call();
      return;
    }
    if (_isFullscreenAdShowing) {
      onDisabled?.call();
      return;
    }
    if (isDeviceOffline) {
      onDisabled?.call();
      return;
    }
    // ignore: use_build_context_synchronously
    navigatorKey?.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => EasySplashAdWith3Inter(
          adNetwork: adNetwork,
          interstitialSplashId: interstitialSplashId,
          interstitialSplashMediumId: interstitialSplashMediumId,
          interstitialSplashHighId: interstitialSplashHighId,
          onShowed: onShowed,
          onDismissed: onDismissed,
          onFailedToLoad: onFailedToLoad,
          onFailedToShow: onFailedToShow,
          onClicked: onClicked,
          onAdLoaded: onAdLoaded,
          onAdShowed: onAdShowed,
          onAdClicked: onAdClicked,
          onAdFailedToLoad: onAdFailedToLoad,
          onAdFailedToShow: onAdFailedToShow,
          onAdDismissed: onAdDismissed,
          onPaidEvent: onPaidEvent,
          config: config,
          onAdMediumLoaded: onAdMediumLoaded,
          onAdMediumShowed: onAdMediumShowed,
          onAdMediumClicked: onAdMediumClicked,
          onAdMediumFailedToLoad: onAdMediumFailedToLoad,
          onAdMediumFailedToShow: onAdMediumFailedToShow,
          onAdMediumDismissed: onAdMediumDismissed,
          onMediumPaidEvent: onMediumPaidEvent,
          configMedium: configMedium,
          onAdHighLoaded: onAdHighLoaded,
          onAdHighShowed: onAdHighShowed,
          onAdHighClicked: onAdHighClicked,
          onAdHighFailedToLoad: onAdHighFailedToLoad,
          onAdHighFailedToShow: onAdHighFailedToShow,
          onAdHighDismissed: onAdHighDismissed,
          onHighPaidEvent: onHighPaidEvent,
          configHigh: configHigh,
        ),
        fullscreenDialog: true,
      ),
      (route) => true,
    );
  }

  Future<void> showSplashAdWithInterstitialAndAppOpen({
    AdNetwork adNetwork = AdNetwork.admob,
    required String interstitialSplashAdId,
    required String appOpenAdId,
    required Function()? onDisabled,
    void Function(AdUnitType type)? onShowed,
    void Function(AdUnitType type)? onDismissed,
    void Function()? onFailedToLoad,
    void Function(AdUnitType type)? onFailedToShow,
    Function(AdUnitType type)? onClicked,
    EasyAdCallback? onAdInterstitialLoaded,
    EasyAdCallback? onAdInterstitialShowed,
    EasyAdCallback? onAdInterstitialClicked,
    EasyAdFailedCallback? onAdInterstitialFailedToLoad,
    EasyAdFailedCallback? onAdInterstitialFailedToShow,
    EasyAdCallback? onAdInterstitialDismissed,
    EasyAdOnPaidEvent? onInterstitialPaidEvent,
    required bool configInterstitial,
    EasyAdCallback? onAdAppOpenLoaded,
    EasyAdCallback? onAdAppOpenShowed,
    EasyAdCallback? onAdAppOpenClicked,
    EasyAdFailedCallback? onAdAppOpenFailedToLoad,
    EasyAdFailedCallback? onAdAppOpenFailedToShow,
    EasyAdCallback? onAdAppOpenDismissed,
    EasyAdOnPaidEvent? onAppOpenPaidEvent,
    required bool configAppOpen,
  }) async {
    if (!isEnabled) {
      onDisabled?.call();
      return;
    }
    if (!configAppOpen && !configInterstitial) {
      onDisabled?.call();
      return;
    }

    if (_isFullscreenAdShowing) {
      onDisabled?.call();
      return;
    }
    if (isDeviceOffline) {
      onDisabled?.call();
      return;
    }
    // ignore: use_build_context_synchronously
    navigatorKey?.currentState?.push(
      MaterialPageRoute(
        builder: (context) => EasySplashAdWithInterstitialAndAppOpen(
          adNetwork: adNetwork,
          interstitialSplashAdId: interstitialSplashAdId,
          appOpenAdId: appOpenAdId,
          onShowed: onShowed,
          onDismissed: onDismissed,
          onFailedToLoad: onFailedToLoad,
          onFailedToShow: onFailedToShow,
          onClicked: onClicked,
          onAdInterstitialLoaded: onAdInterstitialLoaded,
          onAdInterstitialShowed: onAdInterstitialShowed,
          onAdInterstitialClicked: onAdInterstitialClicked,
          onAdInterstitialFailedToLoad: onAdInterstitialFailedToLoad,
          onAdInterstitialFailedToShow: onAdInterstitialFailedToShow,
          onAdInterstitialDismissed: onAdInterstitialDismissed,
          onInterstitialPaidEvent: onInterstitialPaidEvent,
          configInterstitial: configInterstitial,
          onAdAppOpenLoaded: onAdAppOpenLoaded,
          onAdAppOpenShowed: onAdAppOpenShowed,
          onAdAppOpenClicked: onAdAppOpenClicked,
          onAdAppOpenFailedToLoad: onAdAppOpenFailedToLoad,
          onAdAppOpenFailedToShow: onAdAppOpenFailedToShow,
          onAdAppOpenDismissed: onAdAppOpenDismissed,
          onAppOpenPaidEvent: onAppOpenPaidEvent,
          configAppOpen: configAppOpen,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  AdSize getAdmobAdSize({
    EasyAdsBannerType type = EasyAdsBannerType.standard,
  }) {
    if (admobAdSize == null) {
      if (navigatorKey?.currentContext != null) {
        Future(
          () async {
            admobAdSize = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
                MediaQuery.sizeOf(navigatorKey!.currentContext!).width.toInt());
          },
        );
      }
      return AdSize.banner;
    }
    switch (type) {
      case EasyAdsBannerType.standard:
        return AdSize.banner;
      case EasyAdsBannerType.adaptive:
      case EasyAdsBannerType.collapsible_bottom:
      case EasyAdsBannerType.collapsible_top:
        return admobAdSize!;
    }
  }

  bool _isDeviceOffline = false;

  bool get isDeviceOffline => _isDeviceOffline;
  final connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? connectivityStreamSub;
  // StreamSubscription<ConnectivityResult>? connectivityStreamSub;

  Future<void> initConnectivity() async {
    final connectivityResult = await connectivity.checkConnectivity();
    // _isDeviceOffline = connectivityResult != ConnectivityResult.wifi &&
    //     connectivityResult != ConnectivityResult.mobile;
    _isDeviceOffline = !connectivityResult.any(
      (element) =>
          element == ConnectivityResult.wifi ||
          element == ConnectivityResult.mobile ||
          element == ConnectivityResult.vpn,
    );
    cancelConnectivityOnBackground();
    connectivityStreamSub = connectivity.onConnectivityChanged.listen(
      (event) {
        // _isDeviceOffline = event != ConnectivityResult.wifi && event != ConnectivityResult.mobile;
        _isDeviceOffline = !event.any(
          (element) =>
              element == ConnectivityResult.wifi ||
              element == ConnectivityResult.mobile ||
              element == ConnectivityResult.vpn,
        );
      },
    );
  }

  void cancelConnectivityOnBackground() {
    if (connectivityStreamSub != null) {
      connectivityStreamSub!.cancel();
      connectivityStreamSub = null;
    }
  }

  // Future<bool> isDeviceOffline() async {
  //   final connectivityResult = await Connectivity().checkConnectivity();
  //   return !connectivityResult.any(
  //     (element) =>
  //         element == ConnectivityResult.wifi ||
  //         element == ConnectivityResult.mobile ||
  //         element == ConnectivityResult.vpn,
  //   );
  // }

  Future<bool?> getConsentResult() async {
    return await EasyAdPlatform.instance.getConsentResult();
  }

  void logInfo(String message) => _logger.logInfo(message);
}
