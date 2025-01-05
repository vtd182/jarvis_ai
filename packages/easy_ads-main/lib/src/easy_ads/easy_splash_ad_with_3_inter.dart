import 'dart:async';

import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';

class EasySplashAdWith3Inter extends StatefulWidget {
  final AdNetwork adNetwork;
  final String interstitialSplashId;
  final String interstitialSplashMediumId;
  final String interstitialSplashHighId;

  final EasyAdCallback? onAdLoaded;
  final EasyAdCallback? onAdShowed;
  final EasyAdCallback? onAdClicked;
  final EasyAdFailedCallback? onAdFailedToLoad;
  final EasyAdFailedCallback? onAdFailedToShow;
  final EasyAdCallback? onAdDismissed;
  final EasyAdOnPaidEvent? onPaidEvent;
  final bool config;

  final EasyAdCallback? onAdMediumLoaded;
  final EasyAdCallback? onAdMediumShowed;
  final EasyAdCallback? onAdMediumClicked;
  final EasyAdFailedCallback? onAdMediumFailedToLoad;
  final EasyAdFailedCallback? onAdMediumFailedToShow;
  final EasyAdCallback? onAdMediumDismissed;
  final EasyAdOnPaidEvent? onMediumPaidEvent;
  final bool configMedium;

  final EasyAdCallback? onAdHighLoaded;
  final EasyAdCallback? onAdHighShowed;
  final EasyAdCallback? onAdHighClicked;
  final EasyAdFailedCallback? onAdHighFailedToLoad;
  final EasyAdFailedCallback? onAdHighFailedToShow;
  final EasyAdCallback? onAdHighDismissed;
  final EasyAdOnPaidEvent? onHighPaidEvent;
  final bool configHigh;

  final Function(EasyAdsPlacementType type)? onShowed;
  final Function(EasyAdsPlacementType type)? onDismissed;
  final Function()? onFailedToLoad;
  final Function(EasyAdsPlacementType type)? onFailedToShow;
  final Function(EasyAdsPlacementType type)? onClicked;

  const EasySplashAdWith3Inter({
    Key? key,
    this.adNetwork = AdNetwork.admob,
    required this.interstitialSplashId,
    required this.interstitialSplashMediumId,
    required this.interstitialSplashHighId,
    required this.onShowed,
    required this.onDismissed,
    required this.onFailedToLoad,
    required this.onFailedToShow,
    required this.onClicked,
    this.onAdLoaded,
    this.onAdShowed,
    this.onAdClicked,
    this.onAdFailedToLoad,
    this.onAdFailedToShow,
    this.onAdDismissed,
    this.onPaidEvent,
    required this.config,
    this.onAdMediumLoaded,
    this.onAdMediumShowed,
    this.onAdMediumClicked,
    this.onAdMediumFailedToLoad,
    this.onAdMediumFailedToShow,
    this.onAdMediumDismissed,
    this.onMediumPaidEvent,
    required this.configMedium,
    this.onAdHighLoaded,
    this.onAdHighShowed,
    this.onAdHighClicked,
    this.onAdHighFailedToLoad,
    this.onAdHighFailedToShow,
    this.onAdHighDismissed,
    this.onHighPaidEvent,
    required this.configHigh,
  }) : super(key: key);

  @override
  State<EasySplashAdWith3Inter> createState() => _EasySplashAdWith3InterState();
}

class _EasySplashAdWith3InterState extends State<EasySplashAdWith3Inter>
    with WidgetsBindingObserver {
  //
  EasyAdBase? _ads;
  late final EasyAdBase? _interstitialAd;
  late final EasyAdBase? _interstitialMediumAd;
  late final EasyAdBase? _interstitialHighAd;

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
          widget.onAdFailedToLoad
              ?.call(widget.adNetwork, AdUnitType.interstitial, null, "");
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
    _interstitialMediumAd?.dispose();
    _interstitialHighAd?.dispose();
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
      adId: widget.interstitialSplashId,
      onAdClicked: (adNetwork, adUnitType, data) {
        widget.onAdClicked?.call(adNetwork, adUnitType, data);
        widget.onClicked?.call(EasyAdsPlacementType.normal);
      },
      onAdDismissed: (adNetwork, adUnitType, data) {
        if (widget.onShowed == null) {
          Navigator.of(context).pop();
        }
        widget.onAdDismissed?.call(adNetwork, adUnitType, data);
        widget.onDismissed?.call(EasyAdsPlacementType.normal);
        EasyAds.instance.setFullscreenAdShowing(false);
      },
      onAdFailedToLoad: (adNetwork, adUnitType, data, errorMessage) {
        widget.onAdFailedToLoad
            ?.call(adNetwork, adUnitType, data, errorMessage);
      },
      onAdFailedToShow: (adNetwork, adUnitType, data, errorMessage) {
        Navigator.of(context).pop();
        widget.onAdFailedToShow
            ?.call(adNetwork, adUnitType, data, errorMessage);
        widget.onFailedToShow?.call(EasyAdsPlacementType.normal);
        EasyAds.instance.setFullscreenAdShowing(false);
      },
      onAdLoaded: (adNetwork, adUnitType, data) {
        widget.onAdLoaded?.call(adNetwork, adUnitType, data);
      },
      onAdShowed: (adNetwork, adUnitType, data) {
        if (widget.onShowed != null) {
          Navigator.of(context).pop();
          widget.onShowed!.call(EasyAdsPlacementType.normal);
        }
        widget.onAdShowed?.call(adNetwork, adUnitType, data);
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
        widget.onPaidEvent?.call(
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

    _interstitialMediumAd = EasyAds.instance.createInterstitial(
      adNetwork: widget.adNetwork,
      adId: widget.interstitialSplashMediumId,
      onAdClicked: (adNetwork, adUnitType, data) {
        widget.onAdMediumClicked?.call(adNetwork, adUnitType, data);
        widget.onClicked?.call(EasyAdsPlacementType.med);
      },
      onAdDismissed: (adNetwork, adUnitType, data) {
        if (widget.onShowed == null) {
          Navigator.of(context).pop();
        }
        widget.onAdMediumDismissed?.call(adNetwork, adUnitType, data);
        widget.onDismissed?.call(EasyAdsPlacementType.med);
        EasyAds.instance.setFullscreenAdShowing(false);
      },
      onAdFailedToLoad: (adNetwork, adUnitType, data, errorMessage) {
        widget.onAdMediumFailedToLoad
            ?.call(adNetwork, adUnitType, data, errorMessage);
      },
      onAdFailedToShow: (adNetwork, adUnitType, data, errorMessage) {
        Navigator.of(context).pop();
        widget.onAdMediumFailedToShow
            ?.call(adNetwork, adUnitType, data, errorMessage);
        widget.onFailedToShow?.call(EasyAdsPlacementType.med);
        EasyAds.instance.setFullscreenAdShowing(false);
      },
      onAdLoaded: (adNetwork, adUnitType, data) {
        widget.onAdMediumLoaded?.call(adNetwork, adUnitType, data);
      },
      onAdShowed: (adNetwork, adUnitType, data) {
        if (widget.onShowed != null) {
          Navigator.of(context).pop();
          widget.onShowed!.call(EasyAdsPlacementType.med);
        }
        widget.onAdMediumShowed?.call(adNetwork, adUnitType, data);
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
        widget.onMediumPaidEvent?.call(
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

    _interstitialHighAd = EasyAds.instance.createInterstitial(
      adNetwork: widget.adNetwork,
      adId: widget.interstitialSplashHighId,
      onAdClicked: (adNetwork, adUnitType, data) {
        widget.onAdHighClicked?.call(adNetwork, adUnitType, data);
        widget.onClicked?.call(EasyAdsPlacementType.high);
      },
      onAdDismissed: (adNetwork, adUnitType, data) {
        if (widget.onShowed == null) {
          Navigator.of(context).pop();
        }
        widget.onAdHighDismissed?.call(adNetwork, adUnitType, data);
        widget.onDismissed?.call(EasyAdsPlacementType.high);
        EasyAds.instance.setFullscreenAdShowing(false);
      },
      onAdFailedToLoad: (adNetwork, adUnitType, data, errorMessage) {
        widget.onAdHighFailedToLoad
            ?.call(adNetwork, adUnitType, data, errorMessage);
      },
      onAdFailedToShow: (adNetwork, adUnitType, data, errorMessage) {
        Navigator.of(context).pop();
        widget.onAdHighFailedToShow
            ?.call(adNetwork, adUnitType, data, errorMessage);
        widget.onFailedToShow?.call(EasyAdsPlacementType.high);
        EasyAds.instance.setFullscreenAdShowing(false);
      },
      onAdLoaded: (adNetwork, adUnitType, data) {
        widget.onAdHighLoaded?.call(adNetwork, adUnitType, data);
      },
      onAdShowed: (adNetwork, adUnitType, data) {
        if (widget.onShowed != null) {
          Navigator.of(context).pop();
          widget.onShowed!.call(EasyAdsPlacementType.high);
        }
        widget.onAdHighShowed?.call(adNetwork, adUnitType, data);
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
        widget.onHighPaidEvent?.call(
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

    if (widget.configHigh) {
      _interstitialHighAd?.load();
    }
    if (widget.configMedium) {
      _interstitialMediumAd?.load();
    }
    if (widget.config) {
      _interstitialAd?.load();
    }
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_ads != null) {
        _timer?.cancel();
        _timer = null;
        return;
      }
      if (_interstitialHighAd?.isAdLoaded == true) {
        _timer?.cancel();
        _timer = null;
        _ads = _interstitialHighAd;
      } else if (_interstitialMediumAd?.isAdLoaded == true &&
          (_interstitialHighAd?.isAdLoadedFailed == true ||
              !widget.configHigh)) {
        _timer?.cancel();
        _timer = null;
        _ads = _interstitialMediumAd;
      } else if (_interstitialAd?.isAdLoaded == true &&
          (_interstitialHighAd?.isAdLoadedFailed == true ||
              !widget.configHigh) &&
          (_interstitialMediumAd?.isAdLoadedFailed == true ||
              !widget.configMedium)) {
        _timer?.cancel();
        _timer = null;
        _ads = _interstitialAd;
      } else if ((_interstitialHighAd?.isAdLoadedFailed == true ||
              !widget.configHigh) &&
          (_interstitialMediumAd?.isAdLoadedFailed == true ||
              !widget.configMedium) &&
          (_interstitialAd?.isAdLoadedFailed == true || !widget.config)) {
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
