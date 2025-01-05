import 'dart:async';

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../easy_ads_flutter.dart';
import 'easy_loading_ad.dart';

class EasyRePreloadNativeController {
  final AdNetwork adNetwork;

  EasyAdBase? nativeNormal;
  final String? nativeNormalId;
  int loadTimesFailedNativeNormal = 0;

  EasyAdBase? nativeMedium;
  final String? nativeMediumId;
  int loadTimesFailedNativeMedium = 0;

  EasyAdBase? nativeHigh;
  final String? nativeHighId;
  int loadTimesFailedNativeHigh = 0;

  final int limitLoad;

  final ValueNotifier<bool> isPreparing = ValueNotifier(false);

  EasyRePreloadNativeController({
    this.adNetwork = AdNetwork.admob,
    required this.nativeNormalId,
    required this.nativeMediumId,
    required this.nativeHighId,
    this.limitLoad = 3,
  })

  /// Support admob only
  /// Other network will be implement soon!
  : assert(adNetwork == AdNetwork.admob);

  void dispose() {
    nativeNormal?.dispose();
    nativeNormal = null;

    nativeMedium?.dispose();
    nativeMedium = null;

    nativeHigh?.dispose();
    nativeHigh = null;

    isPreparing.dispose();
  }

  Future<void> load() async {
    if (!EasyAds.instance.isEnabled) {
      return;
    }

    if (EasyAds.instance.isDeviceOffline) {
      return;
    }

    if (nativeHigh == null || nativeHigh!.isAdLoadedFailed) {
      loadTimesFailedNativeHigh = 0;
      loadNativeHigh();
    }

    if (nativeMedium == null || nativeMedium!.isAdLoadedFailed) {
      loadTimesFailedNativeMedium = 0;
      loadNativeMedium();
    }

    if (nativeNormal == null || nativeNormal!.isAdLoadedFailed) {
      loadTimesFailedNativeNormal = 0;
      loadNativeNormal();
    }
  }

  Future<void> loadNativeNormal() async {
    if (nativeNormal != null) {
      nativeNormal!.dispose();
      nativeNormal = null;
    }

    if (!EasyAds.instance.isEnabled) {
      return;
    }

    if (EasyAds.instance.isDeviceOffline) {
      return;
    }
    if (nativeNormalId?.isNotEmpty != true) {
      return;
    }
    if (!ConsentManager.ins.canRequestAds) {
      return;
    }

    nativeNormal = EasyAds.instance.createPreloadNative(
      adNetwork: adNetwork,
      adId: nativeNormalId!,
      type: EasyAdsPlacementType.normal,
      onAdFailedToLoad: (adNetwork, adUnitType, data, errorMessage) {
        if (loadTimesFailedNativeNormal < limitLoad) {
          loadTimesFailedNativeNormal++;
          Future.delayed(
            const Duration(milliseconds: 500),
            () => loadNativeNormal(),
          );
        }
      },
      onAdLoaded: (adNetwork, adUnitType, data) {
        loadTimesFailedNativeNormal = 0;
      },
    );

    await nativeNormal!.load();
  }

  Future<void> loadNativeMedium() async {
    if (nativeMedium != null) {
      nativeMedium!.dispose();
      nativeMedium = null;
    }

    if (!EasyAds.instance.isEnabled) {
      return;
    }

    if (EasyAds.instance.isDeviceOffline) {
      return;
    }
    if (nativeMediumId?.isNotEmpty != true) {
      return;
    }
    if (!ConsentManager.ins.canRequestAds) {
      return;
    }

    nativeMedium = EasyAds.instance.createPreloadNative(
      adNetwork: adNetwork,
      adId: nativeMediumId!,
      type: EasyAdsPlacementType.med,
      onAdFailedToLoad: (adNetwork, adUnitType, data, errorMessage) {
        if (loadTimesFailedNativeMedium < limitLoad) {
          loadTimesFailedNativeMedium++;
          Future.delayed(
            const Duration(milliseconds: 500),
            () => loadNativeMedium(),
          );
        }
      },
      onAdLoaded: (adNetwork, adUnitType, data) {
        loadTimesFailedNativeMedium = 0;
      },
    );

    await nativeMedium!.load();
  }

  Future<void> loadNativeHigh() async {
    if (nativeHigh != null) {
      nativeHigh!.dispose();
      nativeHigh = null;
    }

    if (!EasyAds.instance.isEnabled) {
      return;
    }

    if (EasyAds.instance.isDeviceOffline) {
      return;
    }
    if (nativeHighId?.isNotEmpty != true) {
      return;
    }
    if (!ConsentManager.ins.canRequestAds) {
      return;
    }

    nativeHigh = EasyAds.instance.createPreloadNative(
      adNetwork: adNetwork,
      adId: nativeHighId!,
      type: EasyAdsPlacementType.high,
      onAdFailedToLoad: (adNetwork, adUnitType, data, errorMessage) {
        if (loadTimesFailedNativeHigh < limitLoad) {
          loadTimesFailedNativeHigh++;
          Future.delayed(
            const Duration(milliseconds: 500),
            () => loadNativeHigh(),
          );
        }
      },
      onAdLoaded: (adNetwork, adUnitType, data) {
        loadTimesFailedNativeHigh = 0;
      },
    );

    await nativeHigh!.load();
  }

  Future<void> prepareAds(Function(EasyAdBase? adBase)? onPrepaired) async {
    if (!EasyAds.instance.isEnabled) {
      onPrepaired?.call(null);
      return;
    }

    if (EasyAds.instance.isDeviceOffline) {
      onPrepaired?.call(null);
      return;
    }

    if (!isPreparing.value) {
      isPreparing.value = true;
    }

    // Todo: Must check network later
    if (nativeHigh?.isAdLoaded == true &&
        !(nativeHigh as EasyAdmobPreloadNativeAd).isAdShowed) {
      onPrepaired?.call(nativeHigh!);
      return;
    }

    // Todo: Must check network later
    if (nativeMedium?.isAdLoaded == true &&
        !(nativeMedium as EasyAdmobPreloadNativeAd).isAdShowed) {
      onPrepaired?.call(nativeMedium!);
      return;
    }

    // Todo: Must check network later
    if (nativeNormal?.isAdLoaded == true &&
        !(nativeNormal as EasyAdmobPreloadNativeAd).isAdShowed) {
      onPrepaired?.call(nativeNormal!);
      return;
    }

    // Todo: Must check network later
    if ((nativeHigh == null ||
            nativeHigh!.isAdLoadedFailed ||
            (nativeHigh as EasyAdmobPreloadNativeAd).isAdShowed) &&
        (nativeMedium == null ||
            nativeMedium!.isAdLoadedFailed ||
            (nativeMedium as EasyAdmobPreloadNativeAd).isAdShowed) &&
        (nativeNormal == null ||
            nativeNormal!.isAdLoadedFailed ||
            (nativeNormal as EasyAdmobPreloadNativeAd).isAdShowed)) {
      onPrepaired?.call(null);
      return;
    }

    Future.delayed(
      const Duration(milliseconds: 500),
      () => prepareAds(onPrepaired),
    );
  }

  void finishPreloadAd(EasyAdsPlacementType type) {
    switch (type) {
      case EasyAdsPlacementType.normal:
        loadNativeNormal();
        break;
      case EasyAdsPlacementType.med:
        loadNativeMedium();
        break;
      case EasyAdsPlacementType.high:
        loadNativeHigh();
        break;
    }
  }
}

class EasyNativeAdRePreload extends StatefulWidget {
  /// refresh_rate_sec
  final int refreshRateSec;

  final EasyRePreloadNativeController controller;

  final AdNetwork adNetwork;
  final String factoryId;
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

  final bool reloadOnClick;

  final String visibilityDetectorKey;
  final ValueNotifier<bool>? visibilityController;

  const EasyNativeAdRePreload({
    this.adNetwork = AdNetwork.admob,
    required this.refreshRateSec,
    required this.visibilityDetectorKey,
    this.visibilityController,
    required this.factoryId,
    this.onAdLoaded,
    this.onAdShowed,
    this.onAdClicked,
    this.onAdFailedToLoad,
    this.onAdFailedToShow,
    this.onAdDismissed,
    this.onAdDisabled,
    this.onPaidEvent,
    Key? key,
    required this.height,
    this.color,
    required this.borderRadius,
    this.border,
    this.padding,
    this.margin,
    this.reloadOnClick = false,
    required this.controller,
  }) : super(key: key);

  @override
  State<EasyNativeAdRePreload> createState() => _EasyNativeAdRePreloadState();
}

class _EasyNativeAdRePreloadState extends State<EasyNativeAdRePreload>
    with WidgetsBindingObserver {
  EasyAdBase? _nativeAd;
  EasyAdsPlacementType? type;

  Timer? _timer;
  bool _isPaused = false;
  bool _isDestroy = false;
  bool _adFailedToLoad = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.visibilityDetectorKey),
      onVisibilityChanged: (info) {
        if (!mounted) {
          return;
        }
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
        } catch (e) {
          /// visibility error
        }
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
              height: ConsentManager.ins.canRequestAds ? widget.height : 1,
              width: MediaQuery.sizeOf(context).width,
            ),
            child: ValueListenableBuilder(
              valueListenable: widget.controller.isPreparing,
              builder: (_, isPreparing, __) {
                if (isPreparing) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: widget.borderRadius,
                      border: widget.border,
                      color: widget.color,
                    ),
                    padding: widget.padding,
                    margin: widget.margin,
                    child: ClipRRect(
                      borderRadius: widget.borderRadius,
                      child: Container(
                        color: widget.color,
                        height: widget.height,
                        child: EasyLoadingAd(height: widget.height),
                      ),
                    ),
                  );
                }
                if (_nativeAd != null) {
                  return _nativeAd?.show(
                    height: widget.height,
                    borderRadius: widget.borderRadius,
                    color: widget.color,
                    border: widget.border,
                    padding: widget.padding,
                    margin: widget.margin,
                  );
                }
                return SizedBox(
                  height: 1,
                  width: MediaQuery.sizeOf(context).width,
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _prepareAd() async {
    if (!EasyAds.instance.isEnabled) {
      widget.onAdDisabled?.call(widget.adNetwork, AdUnitType.native, null);
      return;
    }
    if (EasyAds.instance.isDeviceOffline) {
      widget.onAdDisabled?.call(widget.adNetwork, AdUnitType.native, null);
      return;
    }
    if (!ConsentManager.ins.canRequestAds) {
      widget.onAdDisabled?.call(widget.adNetwork, AdUnitType.native, null);
      return;
    }

    ConsentManager.ins.handleRequestUmp(
      onPostExecute: () {
        if (ConsentManager.ins.canRequestAds) {
          _initAd();
        } else {
          widget.onAdDisabled?.call(widget.adNetwork, AdUnitType.native, null);
        }
      },
    );
  }

  Future<void> _initAd() async {
    _stopTimer();

    if (_nativeAd != null) {
      _nativeAd!.dispose();
      _nativeAd = null;
      if (mounted) {
        setState(() {});
      }
    }

    if (type != null) {
      widget.controller.finishPreloadAd(type!);
    }

    widget.controller.prepareAds((adBase) async {
      if (adBase == null) {
        int limited = widget.controller.limitLoad;
        if ((widget.controller.loadTimesFailedNativeNormal >= limited ||
                widget.controller.loadTimesFailedNativeMedium >= limited ||
                widget.controller.loadTimesFailedNativeHigh >= limited) &&
            !_adFailedToLoad) {
          _adFailedToLoad = true;
          widget.controller.load();
          _prepareAd();
          return;
        }
        widget.controller.isPreparing.value = false;
        _startTimer();
        return;
      }
      switch (widget.controller.adNetwork) {
        default:
          final admobPreloadNativeAd = adBase as EasyAdmobPreloadNativeAd;
          await admobPreloadNativeAd.setPlatformView(
            factoryId: widget.factoryId,
          );
          admobPreloadNativeAd.updateListener(
            onAdClicked: (adNetwork, adUnitType, data) {
              widget.onAdClicked?.call(adNetwork, adUnitType, data);
              isClicked = true;
              if (mounted) {
                setState(() {});
              }
            },
            onAdDismissed: widget.onAdDismissed,
            onAdShowed: widget.onAdShowed,
            onPaidEvent: widget.onPaidEvent,
            onAdFailedToShow: widget.onAdFailedToShow,
          );
          type = admobPreloadNativeAd.type;
          _nativeAd = admobPreloadNativeAd;
          break;
      }

      widget.controller.isPreparing.value = false;
      _startTimer();

      if (mounted) {
        setState(() {});
      }
    });
    _nativeAd?.load();
    if (mounted) {
      setState(() {});
    }
    if (!visibilityController.value) {
      visibilityController.value = true;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    visibilityController = widget.visibilityController ?? ValueNotifier(true);
    visibilityController.addListener(_listener);
  }

  late final ValueNotifier<bool> visibilityController;

  void _listener() {
    if (_nativeAd?.isAdLoading != true && visibilityController.value) {
      _prepareAd();
      return;
    }

    if (!visibilityController.value) {
      if (_nativeAd != null) {
        _nativeAd!.dispose();
        _nativeAd = null;
        if (mounted) {
          setState(() {});
        }
      }

      _stopTimer();
    }
  }

  @override
  void didChangeDependencies() {
    _prepareAd();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _nativeAd?.dispose();
    onDestroyed();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (isClicked) {
        isClicked = false;
        _prepareAd();
      } else {
        onResume();
      }
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      onPause();
    }
    super.didChangeAppLifecycleState(state);
  }

  void onResume() {
    _isPaused = false;
    if (!_isDestroy) {
      _startTimer();
    }
  }

  void onPause() {
    _isPaused = true;
    _stopTimer();
  }

  void onVisible() {
    _isDestroy = false;
    if (!_isPaused) {
      _startTimer();
    }
  }

  void onDestroyed() {
    _isDestroy = true;
    _stopTimer();
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _startTimer() {
    if (widget.refreshRateSec == 0) {
      return;
    }
    _stopTimer();
    _timer = Timer.periodic(
      Duration(seconds: widget.refreshRateSec),
      (timer) {
        _adFailedToLoad = false;
        _prepareAd();
      },
    );
  }

  bool isClicked = false;
}
