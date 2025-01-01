import 'dart:async';

import 'package:easy_ads_flutter/src/easy_ads/easy_loading_ad.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../easy_ads_flutter.dart';

class EasyNativeAd extends StatefulWidget {
  final AdNetwork adNetwork;
  final String factoryId;
  final String adId;
  final double height;
  final Color? color;
  final BorderRadiusGeometry borderRadius;
  final BoxBorder? border;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  final EasyAdCallback? onAdLoaded;
  final EasyAdCallback? onAdShowed;
  final EasyAdCallback? onAdClicked;
  final EasyAdFailedCallback? onAdFailedToLoad;
  final EasyAdFailedCallback? onAdFailedToShow;
  final EasyAdCallback? onAdDismissed;
  final EasyAdCallback? onAdDisabled;
  final EasyAdOnPaidEvent? onPaidEvent;
  final bool config;

  final bool reloadOnClick;

  final String visibilityDetectorKey;
  final ValueNotifier<bool>? visibilityController;

  const EasyNativeAd({
    this.adNetwork = AdNetwork.admob,
    required this.factoryId,
    required this.adId,
    required this.height,
    this.color,
    this.border,
    this.padding,
    this.margin,
    this.borderRadius = BorderRadius.zero,
    this.onAdLoaded,
    this.onAdShowed,
    this.onAdClicked,
    this.onAdFailedToLoad,
    this.onAdFailedToShow,
    this.onAdDismissed,
    this.onAdDisabled,
    this.onPaidEvent,
    required this.config,
    required this.visibilityDetectorKey,
    this.visibilityController,
    this.reloadOnClick = false,
    Key? key,
  }) : super(key: key);

  @override
  State<EasyNativeAd> createState() => _EasyNativeAdState();
}

class _EasyNativeAdState extends State<EasyNativeAd>
    with WidgetsBindingObserver {
  EasyAdBase? _nativeAd;

  late final ValueNotifier<bool> visibilityController;
  int loadFailedCount = 0;
  static const int maxFailedTimes = 3;
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    visibilityController = widget.visibilityController ?? ValueNotifier(true);
    visibilityController.addListener(_listener);
  }

  @override
  void didChangeDependencies() {
    _prepareAd();
    super.didChangeDependencies();
  }

  void _listener() {
    if (_nativeAd?.isAdLoading != true && visibilityController.value) {
      _prepareAd();
    }
    if (!visibilityController.value) {
      loadFailedCount = 0;

      if (ConsentManager.ins.canRequestAds && !_isLoading.value) {
        _isLoading.value = true;
      }
    }
  }

  Future<void> _prepareAd() async {
    if (loadFailedCount == maxFailedTimes) {
      if (_isLoading.value) {
        _isLoading.value = false;
      }
      return;
    }
    if (!EasyAds.instance.isEnabled) {
      if (_isLoading.value) {
        _isLoading.value = false;
      }
      widget.onAdDisabled?.call(widget.adNetwork, AdUnitType.native, null);
      return;
    }
    if (EasyAds.instance.isDeviceOffline) {
      if (_isLoading.value) {
        _isLoading.value = false;
      }
      widget.onAdDisabled?.call(widget.adNetwork, AdUnitType.native, null);
      return;
    }
    if (!widget.config) {
      if (_isLoading.value) {
        _isLoading.value = false;
      }
      widget.onAdDisabled?.call(widget.adNetwork, AdUnitType.native, null);
      return;
    }
    if (!ConsentManager.ins.canRequestAds) {
      if (_isLoading.value) {
        _isLoading.value = false;
      }
      widget.onAdDisabled?.call(widget.adNetwork, AdUnitType.native, null);
      return;
    }
    if (!_isLoading.value) {
      _isLoading.value = true;
    }
    if (!visibilityController.value) {
      visibilityController.value = true;
    }

    ConsentManager.ins.handleRequestUmp(
      onPostExecute: () {
        if (ConsentManager.ins.canRequestAds) {
          _initAd();
        } else {
          _isLoading.value = false;
          widget.onAdDisabled?.call(widget.adNetwork, AdUnitType.native, null);
        }
      },
    );
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    visibilityController.removeListener(_listener);
    visibilityController.dispose();
    _isLoading.dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  bool isClicked = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (isClicked) {
          isClicked = false;
          _prepareAd();
        }

        break;
      default:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.visibilityDetectorKey),
      onVisibilityChanged: (info) {
        try {
          if (info.visibleFraction < 0.1) {
            if (visibilityController.value) {
              visibilityController.value = false;
            }
          } else {
            if (!visibilityController.value) {
              visibilityController.value = true;
            }
          }
          // ignore: empty_catches
        } catch (e) {}
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: visibilityController,
        builder: (_, isVisible, __) {
          return ValueListenableBuilder(
              valueListenable: _isLoading,
              builder: (adsCtx, isLoading, adsChild) {
                return Stack(
                  children: [
                    Visibility(
                      visible: isVisible,
                      maintainState: false,
                      maintainAnimation: false,
                      maintainSize: false,
                      maintainSemantics: false,
                      maintainInteractivity: false,
                      replacement: SizedBox(
                        height: ConsentManager.ins.canRequestAds
                            ? widget.height
                            : 1,
                        width: MediaQuery.sizeOf(context).width,
                      ),
                      child: _nativeAd?.show(
                            height: widget.height,
                            borderRadius: widget.borderRadius,
                            color: widget.color,
                            border: widget.border,
                            padding: widget.padding,
                            margin: widget.margin,
                          ) ??
                          SizedBox(
                            height: 1,
                            width: MediaQuery.sizeOf(context).width,
                          ),
                    ),
                    if (isLoading)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: widget.borderRadius,
                          border: widget.border,
                          color: widget.color,
                        ),
                        padding: widget.padding,
                        margin: widget.margin,
                        child: ClipRRect(
                          borderRadius: widget.borderRadius,
                          child: SizedBox(
                            height: widget.height,
                            child: EasyLoadingAd(
                              height: widget.height,
                            ),
                          ),
                        ),
                      )
                  ],
                );
              });
        },
      ),
    );
  }

  void _initAd() {
    if (_nativeAd != null) {
      _nativeAd!.dispose();
      _nativeAd = null;
    }

    _nativeAd ??= EasyAds.instance.createNative(
      adNetwork: widget.adNetwork,
      factoryId: widget.factoryId,
      adId: widget.adId,
      onAdClicked: (adNetwork, adUnitType, data) {
        widget.onAdClicked?.call(adNetwork, adUnitType, data);
        isClicked = widget.reloadOnClick;
        if (mounted) {
          setState(() {});
        }
      },
      onAdDismissed: (adNetwork, adUnitType, data) {
        widget.onAdDismissed?.call(adNetwork, adUnitType, data);
        if (mounted) {
          setState(() {});
        }
      },
      onAdFailedToLoad: (adNetwork, adUnitType, data, errorMessage) {
        _isLoading.value = false;
        loadFailedCount++;
        widget.onAdFailedToLoad
            ?.call(adNetwork, adUnitType, data, errorMessage);
        if (mounted) {
          setState(() {});
        }
      },
      onAdFailedToShow: (adNetwork, adUnitType, data, errorMessage) {
        _isLoading.value = false;
        widget.onAdFailedToShow
            ?.call(adNetwork, adUnitType, data, errorMessage);
        if (mounted) {
          setState(() {});
        }
      },
      onAdLoaded: (adNetwork, adUnitType, data) {
        _isLoading.value = false;
        loadFailedCount = 0;

        widget.onAdLoaded?.call(adNetwork, adUnitType, data);
        if (mounted) {
          setState(() {});
        }
      },
      onAdShowed: (adNetwork, adUnitType, data) {
        widget.onAdShowed?.call(adNetwork, adUnitType, data);
        if (mounted) {
          setState(() {});
        }
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
        if (mounted) {
          setState(() {});
        }
      },
    );

    _nativeAd?.load();
    if (mounted) {
      setState(() {});
    }
  }
}
