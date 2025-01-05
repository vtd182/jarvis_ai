enum AdEventType {
  /// When ad network is initialized and ready to load ad units this will be triggered
  /// In case of [adNetworkInitialized], [AdEvent.data] will have a boolean value indicating status of initialization
  adNetworkInitialized,

  /// When ad unit is loaded, this will be triggered
  adLoaded,

  /// When ad unit is clicked, this will be triggered
  adClicked,

  /// When user clicks cross button and close the ad, this will be triggered
  adDismissed,

  /// When ad unit is showed, this will be triggered
  adShowed,

  /// When ad unit is failed to load, this will be triggered
  adFailedToLoad,

  /// When ad unit is failed to show, this will be triggered
  adFailedToShow,

  /// When ad unit is earned reward, this will be triggered
  earnedReward,

  /// When ad unit is paid, this will be triggered
  onPaidEvent,
}
