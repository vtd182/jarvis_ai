import 'package:alice_lightweight/alice.dart';
import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/locator.config.dart';
import 'package:jarvis_ai/retrofit/rest_client.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suga_core/suga_core.dart';

import 'config/config.dart';

final locator = GetIt.instance;

@injectableInit
Future<Unit> setupLocator() async {
  await locator.init();
  return unit;
}

@module
abstract class Locator {
  @lazySingleton
  @preResolve
  Future<SharedPreferences> getSharePreferences() async => SharedPreferences.getInstance();

  @lazySingleton
  Logger getLogger() => Logger(level: Config.logLevel);

  @lazySingleton
  RouteObserver<Route> getRouteObserver() => RouteObserver();

  @lazySingleton
  EventBus getEventBus() => EventBus();

  @lazySingleton
  Alice getAlice() => Alice(
        navigatorKey: Get.key,
      );

  @lazySingleton
  Dio getDio() => locator<RestClient>().dio;
}
