import 'package:jarvis_ai/modules/connection/domain/enums/connection_status.dart';

class ConnectionStatusChangedEvent {
  final ConnectionStatus status;

  ConnectionStatusChangedEvent(this.status);
}
