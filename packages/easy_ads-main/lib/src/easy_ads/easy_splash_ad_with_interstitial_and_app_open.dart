import 'dart:async';

import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';

class EasySplashAdWithInterstitialAndAppOpen extends StatefulWidget {
  final AdNetwork adNetwork;
  final String interstitialSplashAdId;
  final String appOpenAdId;
  final void Function(AdUnitType type)? onShowed;
  final void Function(AdUnitType type)? onDismissed;
  final void Function()? onFailedToLoad;
  final void Function(AdUnitType type)? onFailedToShow;
  final Function(AdUnitType type)? onClicked;

  final EasyAdCallback? onAdInterstitialLoaded;
  final EasyAdCallback? onAdInterstitialShowed;
  final EasyAdCallback? onAdInterstitialClicked;
  final EasyAdFailedCallback? onAdInterstitialFailedToLoad;
  final EasyAdFailedCallback? onAdInterstitialFailedToShow;
  final EasyAdCallback? onAdInterstitialDismissed;
  final EasyAdOnPaidEvent? onInterstitialPaidEvent;
  final bool configInterstitial;

  final EasyAdCallback? onAdAppOpenLoaded;
  final EasyAdCallback? onAdAppOpenShowed;
  final EasyAdCallback? onAdAppOpenClicked;
  final EasyAdFailedCallback? onAdAppOpenFailedToLoad;
  final EasyAdFailedCallback? onAdAppOpenFailedToShow;
  final EasyAdCallback? onAdAppOpenDismissed;
  final EasyAdOnPaidEvent? onAppOpenPaidEvent;
  final bool configAppOpen;

  const EasySplashAdWithInterstitialAndAppOpen({
    Key? key,
    this.adNetwork = AdNetwork.admob,
    required this.interstitialSplashAdId,
    required this.appOpenAdId,
    required this.onShowed,
    required this.onDismissed,
    required this.onFailedToLoad,
    required this.onFailedToShow,
    required this.onClicked,
    this.onAdInterstitialLoaded,
    this.onAdInterstitialShowed,
    this.onAdInterstitialClicked,
    this.onAdInterstitialFailedToLoad,
    this.onAdInterstitialFailedToShow,
    this.onAdInterstitialDismissed,
    this.onInterstitialPaidEvent,
    required this.configInterstitial,
    this.onAdAppOpenLoaded,
    this.onAdAppOpenShowed,
    this.onAdAppOpenClicked,
    this.onAdAppOpenFailedToLoad,
    this.onAdAppOpenFailedToShow,
    this.onAdAppOpenDismissed,
    this.onAppOpenPaidEvent,
    required this.configAppOpen,
  }) : super(key: key);

  @override
  State<EasySplashAdWithInterstitialAndAppOpen> createState() =>
      _EasySplashAdWithInterstitialAndAppOpenState();
}

class _EasySplashAdWithInterstitialAndAppOpenState
    extends State<EasySplashAdWithInterstitialAndAppOpen> with WidgetsBindingObserver {
  //
  EasyAdBase? _ads;
  late final EasyAdBase? _interstitialAd;
  late final EasyAdBase? _appOpenAd;

  Timer? _timer;

  AppLifecycleState _appLifecycleState = AppLifecycleState.resumed;
  bool _adFailedToShow = false;
  bool _isAdShowed = false;

  Future<void> _showAd() => Future.delayed(
        const Duration(milliseconds: 500),
        () {
          if (_appLifecycleState == AppLifecycleState.resumed && !_isAdShowed) {
            if (_ads != null && mounted) {
              _ads!.show();
              _isAdShowed = true;
            }
          } else {
            _adFailedToShow = true;
          }
        },
      );

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    EasyAds.instance.setFullscreenAdShowing(true);

    ConsentManager.ins.handleRequestUmp(
      onPostExecute: () {
        if (ConsentManager.ins.canRequestAds) {
          _initAds();
        } else {
          if (mounted) {
            Navigator.of(context).pop();
          }
          widget.onFailedToLoad?.call();
          EasyAds.instance.setFullscreenAdShowing(false);
        }
      },
    );
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appLifecycleState = state;
    if (state == AppLifecycleState.resumed && _adFailedToShow && !_isAdShowed) {
      _showAd();
    } else if (state == AppLifecycleState.paused) {}
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _interstitialAd?.dispose();
    _appOpenAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const PopScope(
      canPop: false,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Loading Ads',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _initAds() {
    _interstitialAd = EasyAds.instance.createInterstitial(
      adNetwork: widget.adNetwork,
      adId: widget.interstitialSplashAdId,
      onAdClicked: (adNetwork, adUnitType, data) {
        widget.onAdInterstitialClicked?.call(adNetwork, adUnitType, data);
        widget.onClicked?.call(AdUnitType.interstitial);
      },
      onAdDismissed: (adNetwork, adUnitType, data) {
        if (widget.onShowed == null) {
          Navigator.of(context).pop();
        }
        widget.onAdInterstitialDismissed?.call(adNetwork, adUnitType, data);
        widget.onDismissed?.call(AdUnitType.interstitial);
        EasyAds.instance.setFullscreenAdShowing(false);
      },
      onAdFailedToLoad: (adNetwork, adUnitType, data, errorMessage) {
        widget.onAdInterstitialFailedToLoad?.call(adNetwork, adUnitType, data, errorMessage);
      },
      onAdFailedToShow: (adNetwork, adUnitType, data, errorMessage) {
        Navigator.of(context).pop();
        widget.onAdInterstitialFailedToShow?.call(adNetwork, adUnitType, data, errorMessage);
        widget.onFailedToShow?.call(AdUnitType.interstitial);
        EasyAds.instance.setFullscreenAdShowing(false);
      },
      onAdLoaded: (adNetwork, adUnitType, data) {
        widget.onAdInterstitialLoaded?.call(adNetwork, adUnitType, data);
      },
      onAdShowed: (adNetwork, adUnitType, data) {
        if (widget.onShowed != null) {
          Navigator.of(context).pop();
          widget.onShowed!.call(AdUnitType.interstitial);
        }
        widget.onAdInterstitialShowed?.call(adNetwork, adUnitType, data);
      },
      onPaidEvent: ({
        required AdNetwork adNetwork,
        required AdUnitType adUnitType,
        required double revenue,
        required String currencyCode,
        String? network,
        String? unit,
        String? placement,
      }) {
        widget.onInterstitialPaidEvent?.call(
          adNetwork: adNetwork,
          adUnitType: adUnitType,
          revenue: revenue,
          currencyCode: currencyCode,
          network: network,
          unit: unit,
          placement: placement,
        );
      },
    );

    _appOpenAd = EasyAds.instance.createAppOpenAd(
      adNetwork: widget.adNetwork,
      adId: widget.appOpenAdId,
      onAdClicked: (adNetwork, adUnitType, data) {
        widget.onAdAppOpenClicked?.call(adNetwork, adUnitType, data);
        widget.onClicked?.call(AdUnitType.appOpen);
      },
      onAdDismissed: (adNetwork, adUnitType, data) {
        if (widget.onShowed == null) {
          Navigator.of(context).pop();
        }
        widget.onAdAppOpenDismissed?.call(adNetwork, adUnitType, data);
        widget.onDismissed?.call(AdUnitType.appOpen);
        EasyAds.instance.setFullscreenAdShowing(false);
      },
      onAdFailedToLoad: (adNetwork, adUnitType, data, errorMessage) {
        widget.onAdAppOpenFailedToLoad?.call(adNetwork, adUnitType, data, errorMessage);
      },
      onAdFailedToShow: (adNetwork, adUnitType, data, errorMessage) {
        Navigator.of(context).pop();
        widget.onAdAppOpenFailedToShow?.call(adNetwork, adUnitType, data, errorMessage);
        widget.onFailedToShow?.call(AdUnitType.appOpen);
        EasyAds.instance.setFullscreenAdShowing(false);
      },
      onAdLoaded: (adNetwork, adUnitType, data) {
        widget.onAdAppOpenLoaded?.call(adNetwork, adUnitType, data);
      },
      onAdShowed: (adNetwork, adUnitType, data) {
        if (widget.onShowed != null) {
          Navigator.of(context).pop();
          widget.onShowed!.call(AdUnitType.appOpen);
        }
        widget.onAdAppOpenShowed?.call(adNetwork, adUnitType, data);
      },
      onPaidEvent: ({
        required AdNetwork adNetwork,
        required AdUnitType adUnitType,
        required double revenue,
        required String currencyCode,
        String? network,
        String? unit,
        String? placement,
      }) {
        widget.onAppOpenPaidEvent?.call(
          adNetwork: adNetwork,
          adUnitType: adUnitType,
          revenue: revenue,
          currencyCode: currencyCode,
          network: network,
          unit: unit,
          placement: placement,
        );
      },
    );

    if (widget.configAppOpen) {
      _appOpenAd?.load();
    }

    if (widget.configInterstitial) {
      _interstitialAd?.load();
    }
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_ads != null) {
        _timer?.cancel();
        _timer = null;
        return;
      }
      if (_appOpenAd?.isAdLoaded == true) {
        _timer?.cancel();
        _timer = null;
        _ads = _appOpenAd;
      } else if (_interstitialAd?.isAdLoaded == true &&
          (_appOpenAd?.isAdLoadedFailed == true || !widget.configAppOpen)) {
        _timer?.cancel();
        _timer = null;
        _ads = _interstitialAd;
      } else if ((_appOpenAd?.isAdLoadedFailed == true || !widget.configAppOpen) &&
          (_interstitialAd?.isAdLoadedFailed == true || !widget.configInterstitial)) {
        _timer?.cancel();
        _timer = null;
        Navigator.of(context).pop();
        widget.onFailedToLoad?.call();
        EasyAds.instance.setFullscreenAdShowing(false);
        return;
      }

      if (_ads != null) {
        _showAd();
      }
    });
  }
}
