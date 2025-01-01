import 'dart:async';

import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'easy_loading_ad.dart';

class EasyNative2Ad extends StatefulWidget {
  final AdNetwork adNetwork;
  final String factoryId;
  final String adId;
  final String adIdHigh;
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
  final String visibilityDetectorKey;

  final EasyAdCallback? onAdHighLoaded;
  final EasyAdCallback? onAdHighShowed;
  final EasyAdCallback? onAdHighClicked;
  final EasyAdFailedCallback? onAdHighFailedToLoad;
  final EasyAdFailedCallback? onAdHighFailedToShow;
  final EasyAdCallback? onAdHighDismissed;
  final EasyAdCallback? onAdHighDisabled;
  final EasyAdOnPaidEvent? onHighPaidEvent;
  final bool configHigh;
  final ValueNotifier<bool>? visibilityController;

  final bool reloadOnClick;

  final Function(EasyAdsPlacementType type)? onShowed;
  final Function(EasyAdsPlacementType type)? onDismissed;
  final Function()? onFailedToLoad;
  final Function(EasyAdsPlacementType type)? onFailedToShow;
  final Function(EasyAdsPlacementType type)? onClicked;

  const EasyNative2Ad({
    this.adNetwork = AdNetwork.admob,
    required this.factoryId,
    this.visibilityController,
    required this.adId,
    required this.adIdHigh,
    required this.height,
    required this.visibilityDetectorKey,
    this.color,
    this.borderRadius = BorderRadius.zero,
    this.border,
    this.padding,
    this.margin,
    this.onAdLoaded,
    this.onAdShowed,
    this.onAdClicked,
    this.onAdFailedToLoad,
    this.onAdFailedToShow,
    this.onAdDismissed,
    this.onAdDisabled,
    this.onPaidEvent,
    required this.config,
    this.onAdHighLoaded,
    this.onAdHighShowed,
    this.onAdHighClicked,
    this.onAdHighFailedToLoad,
    this.onAdHighFailedToShow,
    this.onAdHighDismissed,
    this.onAdHighDisabled,
    this.onHighPaidEvent,
    required this.configHigh,
    required this.onShowed,
    required this.onDismissed,
    required this.onFailedToLoad,
    required this.onFailedToShow,
    required this.onClicked,
    this.reloadOnClick = false,
    Key? key,
  }) : super(key: key);

  @override
  State<EasyNative2Ad> createState() => _EasyNative2AdState();
}

class _EasyNative2AdState extends State<EasyNative2Ad>
    with WidgetsBindingObserver {
  EasyAdBase? _ad;
  bool isClicked = false;
  late final ValueNotifier<bool> visibilityController;
  int loadFailedCount = 0;
  static const int maxFailedTimes = 3;

  EasyAdBase? _nativeAd;
  EasyAdBase? _nativeAdHigh;

  Timer? _timer;
  bool _isAdLoaded = false;
  bool _isAdLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    visibilityController = widget.visibilityController ?? ValueNotifier(true);
    visibilityController.addListener(_listener);
  }

  @override
  void didChangeDependencies() {
    _prepareAds();
    super.didChangeDependencies();
  }

  void _listener() {
    if (_ad?.isAdLoading != true && visibilityController.value) {
      _prepareAds();
    }
    if (!visibilityController.value) {
      loadFailedCount = 0;
    }
  }

  Future<void> _prepareAds() async {
    if (loadFailedCount >= maxFailedTimes) {
      return;
    }
    if (!EasyAds.instance.isEnabled) {
      widget.onAdDisabled?.call(widget.adNetwork, AdUnitType.native, null);
      widget.onAdHighDisabled?.call(widget.adNetwork, AdUnitType.native, null);
      return;
    }
    if (EasyAds.instance.isDeviceOffline) {
      widget.onAdDisabled?.call(widget.adNetwork, AdUnitType.native, null);
      widget.onAdHighDisabled?.call(widget.adNetwork, AdUnitType.native, null);
      return;
    }

    if (!widget.config) {
      widget.onAdDisabled?.call(widget.adNetwork, AdUnitType.native, null);
    }

    if (!widget.configHigh) {
      widget.onAdHighDisabled?.call(widget.adNetwork, AdUnitType.native, null);
    }

    if (!widget.config && !widget.configHigh) {
      return;
    }
    if (!ConsentManager.ins.canRequestAds) {
      widget.onAdDisabled?.call(widget.adNetwork, AdUnitType.native, null);
      widget.onAdHighDisabled?.call(widget.adNetwork, AdUnitType.native, null);
      return;
    }

    ConsentManager.ins.handleRequestUmp(
      onPostExecute: () {
        if (ConsentManager.ins.canRequestAds) {
          _initAds();
        } else {
          _isAdLoading = false;
          widget.onAdDisabled?.call(widget.adNetwork, AdUnitType.native, null);
          widget.onAdHighDisabled
              ?.call(widget.adNetwork, AdUnitType.native, null);
        }
      },
    );
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    _nativeAdHigh?.dispose();
    _timer?.cancel();
    _timer = null;

    visibilityController.removeListener(_listener);
    visibilityController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (isClicked) {
          isClicked = false;
          _prepareAds();
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
            return Visibility(
              visible: isVisible,
              maintainState: false,
              maintainAnimation: false,
              maintainSize: false,
              maintainSemantics: false,
              maintainInteractivity: false,
              replacement: SizedBox(
                height: widget.height,
                width: MediaQuery.sizeOf(context).width,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (_isAdLoading) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: widget.borderRadius,
                        border: widget.border,
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
                    );
                  }
                  if (_ad == null || !_isAdLoaded) {
                    return const SizedBox(
                      width: 1,
                      height: 1,
                    );
                  }
                  return _ad!.show(
                    height: widget.height,
                    borderRadius: widget.borderRadius,
                    color: widget.color,
                    border: widget.border,
                    padding: widget.padding,
                    margin: widget.margin,
                  );
                },
              ),
            );
          }),
    );
  }

  void _initAds() {
    if (_nativeAd != null) {
      _nativeAd!.dispose();
      _nativeAd = null;
    }
    if (_nativeAdHigh != null) {
      _nativeAdHigh!.dispose();
      _nativeAdHigh = null;
    }

    _nativeAd ??= EasyAds.instance.createNative(
      adNetwork: widget.adNetwork,
      factoryId: widget.factoryId,
      adId: widget.adId,
      onAdClicked: (adNetwork, adUnitType, data) {
        widget.onAdClicked?.call(adNetwork, adUnitType, data);
        widget.onClicked?.call(EasyAdsPlacementType.normal);
        isClicked = widget.reloadOnClick;
        if (mounted) {
          setState(() {});
        }
      },
      onAdDismissed: (adNetwork, adUnitType, data) {
        widget.onAdDismissed?.call(adNetwork, adUnitType, data);
        widget.onDismissed?.call(EasyAdsPlacementType.normal);
        if (mounted) {
          setState(() {});
        }
      },
      onAdFailedToLoad: (adNetwork, adUnitType, data, errorMessage) {
        loadFailedCount++;
        widget.onAdFailedToLoad
            ?.call(adNetwork, adUnitType, data, errorMessage);
        if (mounted) {
          setState(() {});
        }
      },
      onAdFailedToShow: (adNetwork, adUnitType, data, errorMessage) {
        widget.onAdFailedToShow
            ?.call(adNetwork, adUnitType, data, errorMessage);
        widget.onFailedToShow?.call(EasyAdsPlacementType.normal);
        if (mounted) {
          setState(() {});
        }
      },
      onAdLoaded: (adNetwork, adUnitType, data) {
        loadFailedCount = 0;
        widget.onAdLoaded?.call(adNetwork, adUnitType, data);
        if (mounted) {
          setState(() {});
        }
      },
      onAdShowed: (adNetwork, adUnitType, data) {
        widget.onAdShowed?.call(adNetwork, adUnitType, data);
        widget.onShowed?.call(EasyAdsPlacementType.normal);
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
        visibilityController.value = true;
      },
    );

    _nativeAdHigh ??= EasyAds.instance.createNative(
      adNetwork: widget.adNetwork,
      factoryId: widget.factoryId,
      adId: widget.adIdHigh,
      onAdClicked: (adNetwork, adUnitType, data) {
        widget.onAdHighClicked?.call(adNetwork, adUnitType, data);
        widget.onClicked?.call(EasyAdsPlacementType.high);
        isClicked = widget.reloadOnClick;
        if (mounted) {
          setState(() {});
        }
      },
      onAdDismissed: (adNetwork, adUnitType, data) {
        widget.onAdHighDismissed?.call(adNetwork, adUnitType, data);
        widget.onClicked?.call(EasyAdsPlacementType.high);
        if (mounted) {
          setState(() {});
        }
      },
      onAdFailedToLoad: (adNetwork, adUnitType, data, errorMessage) {
        loadFailedCount++;
        widget.onAdHighFailedToLoad
            ?.call(adNetwork, adUnitType, data, errorMessage);
        if (mounted) {
          setState(() {});
        }
      },
      onAdFailedToShow: (adNetwork, adUnitType, data, errorMessage) {
        widget.onAdHighFailedToShow
            ?.call(adNetwork, adUnitType, data, errorMessage);
        widget.onFailedToShow?.call(EasyAdsPlacementType.high);
        if (mounted) {
          setState(() {});
        }
      },
      onAdLoaded: (adNetwork, adUnitType, data) {
        loadFailedCount = 0;
        widget.onAdHighLoaded?.call(adNetwork, adUnitType, data);
        if (mounted) {
          setState(() {});
        }
      },
      onAdShowed: (adNetwork, adUnitType, data) {
        widget.onAdHighShowed?.call(adNetwork, adUnitType, data);
        widget.onShowed?.call(EasyAdsPlacementType.high);
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
        widget.onHighPaidEvent?.call(
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
        visibilityController.value = true;
      },
    );

    _isAdLoading = true;
    if (mounted) {
      setState(() {});
    }
    if (widget.configHigh) {
      _nativeAdHigh?.load();
    }

    if (widget.config) {
      _nativeAd?.load();
    }

    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_nativeAdHigh?.isAdLoaded == true) {
        _timer?.cancel();
        _timer = null;
        _ad = _nativeAdHigh;
        _isAdLoaded = true;
        if (mounted) {
          setState(() {});
        }
      } else if (_nativeAd?.isAdLoaded == true &&
          (_nativeAdHigh?.isAdLoadedFailed == true || !widget.configHigh)) {
        _timer?.cancel();
        _timer = null;
        _ad = _nativeAd;
        _isAdLoaded = true;
        if (mounted) {
          setState(() {});
        }
      } else if ((_nativeAd?.isAdLoadedFailed == true || !widget.config) &&
          (_nativeAdHigh?.isAdLoadedFailed == true || !widget.configHigh)) {
        _timer?.cancel();
        _timer = null;
        widget.onFailedToLoad?.call();
        _isAdLoaded = false;
        if (mounted) {
          setState(() {});
        }
      }
      if (_timer == null) {
        _isAdLoading = false;
        if (mounted) {
          setState(() {});
        }
      }
    });
  }
}
