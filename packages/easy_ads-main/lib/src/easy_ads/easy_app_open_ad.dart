import 'dart:async';

import 'package:flutter/material.dart';

import '../../easy_ads_flutter.dart';

class EasyAppOpenAd extends StatefulWidget {
  final AdNetwork adNetwork;
  final String adId;
  final EasyAdCallback? onAdLoaded;
  final EasyAdCallback? onAdShowed;
  final EasyAdCallback? onAdClicked;
  final EasyAdFailedCallback? onAdFailedToLoad;
  final EasyAdFailedCallback? onAdFailedToShow;
  final EasyAdCallback? onAdDismissed;
  final EasyAdEarnedReward? onEarnedReward;
  final EasyAdOnPaidEvent? onPaidEvent;

  const EasyAppOpenAd({
    Key? key,
    this.adNetwork = AdNetwork.admob,
    required this.adId,
    this.onAdLoaded,
    this.onAdShowed,
    this.onAdClicked,
    this.onAdFailedToLoad,
    this.onAdFailedToShow,
    this.onAdDismissed,
    this.onEarnedReward,
    this.onPaidEvent,
  }) : super(key: key);

  /// return the current route of this class, use to remove from stack
  static DialogRoute? currentRoute;

  static DialogRoute getRoute({
    required BuildContext context,
    required String adId,
    AdNetwork adNetwork = AdNetwork.admob,
    EasyAdCallback? onAdLoaded,
    EasyAdCallback? onAdShowed,
    EasyAdCallback? onAdClicked,
    EasyAdFailedCallback? onAdFailedToLoad,
    EasyAdFailedCallback? onAdFailedToShow,
    EasyAdCallback? onAdDismissed,
    EasyAdEarnedReward? onEarnedReward,
    EasyAdOnPaidEvent? onPaidEvent,
  }) {
    currentRoute = null;
    currentRoute = DialogRoute(
      context: context,
      builder: (context) => EasyAppOpenAd(
        adId: adId,
        adNetwork: adNetwork,
        onAdLoaded: onAdLoaded,
        onAdShowed: onAdShowed,
        onAdClicked: onAdClicked,
        onAdFailedToLoad: onAdFailedToLoad,
        onAdFailedToShow: onAdFailedToShow,
        onAdDismissed: onAdDismissed,
        onEarnedReward: onEarnedReward,
        onPaidEvent: onPaidEvent,
      ),
    );

    return currentRoute!;
  }

  @override
  State<EasyAppOpenAd> createState() => _EasyAppOpenAdState();
}

class _EasyAppOpenAdState extends State<EasyAppOpenAd> with WidgetsBindingObserver {
  late final EasyAdBase? _appOpenAd;

  Future<void> _showAd() => Future.delayed(
        const Duration(milliseconds: 500),
        () {
          if (_appLifecycleState == AppLifecycleState.resumed) {
            if (mounted) {
              _appOpenAd!.show();
            }
          } else {
            _adFailedToShow = true;
          }
        },
      );

  void _closeAd() {
    if (EasyAppOpenAd.currentRoute != null) {
      Navigator.of(context).removeRoute(EasyAppOpenAd.currentRoute as Route);
      EasyAppOpenAd.currentRoute = null;
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    EasyAds.instance.setFullscreenAdShowing(true);
    ConsentManager.ins.handleRequestUmp(
      onPostExecute: () {
        if (ConsentManager.ins.canRequestAds) {
          initAndLoadAd();
        } else {
          if (mounted) {
            _closeAd();
          }
          widget.onAdFailedToLoad?.call(widget.adNetwork, AdUnitType.appOpen, null, "");
          EasyAds.instance.setFullscreenAdShowing(false);
        }
      },
    );
    super.initState();
  }

  AppLifecycleState _appLifecycleState = AppLifecycleState.resumed;
  bool _adFailedToShow = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appLifecycleState = state;
    if (state == AppLifecycleState.resumed && _adFailedToShow) {
      _showAd();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void initAndLoadAd() {
    _appOpenAd = EasyAds.instance.createAppOpenAd(
      adNetwork: widget.adNetwork,
      adId: widget.adId,
      onAdLoaded: (adNetwork, adUnitType, data) {
        widget.onAdLoaded?.call(adNetwork, adUnitType, data);
        _showAd();
      },
      onAdClicked: (adNetwork, adUnitType, data) {
        widget.onAdClicked?.call(adNetwork, adUnitType, data);
      },
      onAdDismissed: (adNetwork, adUnitType, data) {
        if (widget.onAdShowed == null) {
          _closeAd();
        }
        widget.onAdDismissed?.call(adNetwork, adUnitType, data);
        EasyAds.instance.setFullscreenAdShowing(false);
      },
      onAdFailedToLoad: (adNetwork, adUnitType, data, errorMessage) {
        widget.onAdFailedToLoad?.call(adNetwork, adUnitType, data, errorMessage);
        if (mounted) {
          _closeAd();
        }
        EasyAds.instance.setFullscreenAdShowing(false);
      },
      onAdFailedToShow: (adNetwork, adUnitType, data, errorMessage) {
        widget.onAdFailedToShow?.call(adNetwork, adUnitType, data, errorMessage);
        if (mounted) {
          _closeAd();
        }
        EasyAds.instance.setFullscreenAdShowing(false);
      },
      onAdShowed: (adNetwork, adUnitType, data) {
        if (widget.onAdShowed != null) {
          _closeAd();
          widget.onAdShowed!.call(adNetwork, adUnitType, data);
        }
      },
      onEarnedReward: (adNetwork, adUnitType, rewardType, rewardAmount) {
        widget.onEarnedReward?.call(adNetwork, adUnitType, rewardType, rewardAmount);
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
    _appOpenAd?.load();
  }

  @override
  Widget build(BuildContext context) {
    return const PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
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
              'Welcome back',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
