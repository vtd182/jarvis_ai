import 'dart:async';

import 'package:logger/logger.dart';

import '../easy_ads.dart';
import '../enums/ad_event_type.dart';
import 'ad_event.dart';

/// [EasyLogger] is used to listen to the callbacks in stream & show logs
class EasyLogger {
  /// [Logger] is used to show logs in console for EasyAds
  final _logger = Logger();
  StreamSubscription? streamSubscription;

  void enable(bool enabled) {
    streamSubscription?.cancel();
    if (enabled) {
      streamSubscription = EasyAds.instance.onEvent.listen(_onAdEvent);
    }
  }

  void logInfo(String message) => _logger.i(message);

  void _onAdNetworkInitialized(AdEvent event) {
    if (event.data == true) {
      _logger.i(
          "${event.adNetwork.name} has been initialized and is ready to use.");
    } else {
      _logger.e("${event.adNetwork.name} could not be initialized.");
    }
  }

  void _onAdLoaded(AdEvent event) {
    _logger.i(
        "${event.adUnitType?.name} ads for ${event.adNetwork.name} have been loaded.");
  }

  void _onAdFailedToLoad(AdEvent event) {
    _logger.e(
        "${event.adUnitType?.name} ads for ${event.adNetwork.name} could not be loaded.\nERROR: ${event.error}");
  }

  void _onAdShowed(AdEvent event) {
    _logger.i(
        "${event.adUnitType?.name} ad for ${event.adNetwork.name} has been shown.");
  }

  void _onAdFailedShow(AdEvent event) {
    _logger.e(
        "${event.adUnitType?.name} ad for ${event.adNetwork.name} could not be showed.\nERROR: ${event.error}");
  }

  void _onAdDismissed(AdEvent event) {
    _logger.i(
        "${event.adUnitType?.name} ad for ${event.adNetwork.name} has been dismissed.");
  }

  void _onEarnedReward(AdEvent event) {
    final dataMap = event.data as Map<String, dynamic>?;
    _logger.i(
        "User has earned ${dataMap?['rewardAmount']} of ${dataMap?['rewardType']} from ${event.adNetwork.name}");
  }

  void _onPaidEvent(AdEvent event) {
    final dataMap = event.data as Map<String, dynamic>?;
    _logger.i(
        "User has earned ${dataMap?['revenue']} ${dataMap?['currencyCode']} from ${event.adNetwork.name}");
  }

  void _onAdClicked(AdEvent event) {
    _logger.i(
        "${event.adUnitType?.name} ads for ${event.adNetwork.name} have been clicked.");
  }

  void _onAdEvent(AdEvent event) {
    switch (event.type) {
      case AdEventType.adNetworkInitialized:
        _onAdNetworkInitialized(event);
        break;
      case AdEventType.adLoaded:
        _onAdLoaded(event);
        break;
      case AdEventType.adDismissed:
        _onAdDismissed(event);
        break;
      case AdEventType.adShowed:
        _onAdShowed(event);
        break;
      case AdEventType.adFailedToLoad:
        _onAdFailedToLoad(event);
        break;
      case AdEventType.adFailedToShow:
        _onAdFailedShow(event);
        break;
      case AdEventType.earnedReward:
        _onEarnedReward(event);
        break;
      case AdEventType.onPaidEvent:
        _onPaidEvent(event);
        break;
      case AdEventType.adClicked:
        _onAdClicked(event);
        break;
    }
  }
}
