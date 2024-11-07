import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jarvis_ai/locator.dart';
import 'package:jarvis_ai/modules/connection/domain/enums/connection_status.dart';
import 'package:jarvis_ai/modules/connection/domain/events/connection_status_changed_event.dart';
import 'package:jarvis_ai/modules/connection/domain/usecases/handle_connection_status_changed_usecase.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  StreamSubscription? _internetConnectionStatusChangedListener;
  StreamSubscription? _connectionStatusChangedListener;

  ConnectionStatus _connectionStatus = ConnectionStatus.connected;

  @override
  void initState() {
    super.initState();
    _internetConnectionStatusChangedListener = InternetConnectionChecker().onStatusChange.listen(
          locator<HandleConnectionStatusChangedUsecase>().run,
        );
    _connectionStatusChangedListener = locator<EventBus>().on<ConnectionStatusChangedEvent>().listen((event) {
      setState(() => _connectionStatus = event.status);
    });
  }

  @override
  void dispose() {
    _internetConnectionStatusChangedListener?.cancel();
    _connectionStatusChangedListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (_connectionStatus) {
      case ConnectionStatus.connected:
        return const SizedBox();
      case ConnectionStatus.connectedRecently:
        return _buildWidget(context, Colors.green, "Connected");
      case ConnectionStatus.disconnected:
        return _buildWidget(context, Colors.red, "Disconnected");
    }
  }

  Widget _buildWidget(BuildContext context, Color backgroundColor, String text) {
    final height = MediaQuery.of(context).padding.top;
    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: EdgeInsets.only(top: height),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            alignment: Alignment.center,
            height: 24.h,
            padding: EdgeInsets.all(5.h),
            color: backgroundColor,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
