import 'package:firebase_analytics/firebase_analytics.dart';

class EventLog {
  static final FirebaseAnalytics _log = FirebaseAnalytics.instance;

  static void logScreenView(String className, String screenName) {
    _log.logScreenView(screenClass: className, screenName: screenName);
  }

  static void logEvent(String eventName, {Map<String, Object>? params}) {
    _log.logEvent(name: eventName, parameters: params);
  }
}