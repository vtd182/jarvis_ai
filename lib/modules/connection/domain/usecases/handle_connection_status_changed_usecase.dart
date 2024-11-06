import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jarvis_ai/modules/connection/domain/enums/connection_status.dart';
import 'package:jarvis_ai/modules/connection/domain/events/connection_status_changed_event.dart';

@lazySingleton
class HandleConnectionStatusChangedUsecase {
  static const int connectedRecentlyTimeout = 3000;

  InternetConnectionStatus _lastStatus = InternetConnectionStatus.connected;
  Timer? _timer;

  final EventBus _eventBus;

  HandleConnectionStatusChangedUsecase(this._eventBus);

  void run(InternetConnectionStatus status) {
    if (_lastStatus == status) {
      return;
    }

    switch (status) {
      case InternetConnectionStatus.disconnected:
        _timer?.cancel();
        _eventBus.fire(ConnectionStatusChangedEvent(ConnectionStatus.disconnected));
        break;
      case InternetConnectionStatus.connected:
        _eventBus.fire(ConnectionStatusChangedEvent(ConnectionStatus.connectedRecently));
        _timer = Timer(const Duration(milliseconds: connectedRecentlyTimeout), () {
          _eventBus.fire(ConnectionStatusChangedEvent(ConnectionStatus.connected));
        });
        break;
    }
    _lastStatus = status;
  }
}
