import 'dart:ui';
import 'package:flutter/foundation.dart';

import '../../easy_ads_flutter.dart';

class ConsentManager {
  static ConsentManager ins = ConsentManager._();

  ConsentManager._();

  static bool _canRequestAds = false;

  bool get canRequestAds => _canRequestAds;

  bool _isMediationInitialized = false;

  bool debugUmp = false;
  List<String>? testIdentifiers;

  ConsentDebugSettings get _debugSettings => ConsentDebugSettings(
        debugGeography: DebugGeography.debugGeographyEea,
        testIdentifiers: testIdentifiers,
      );

  Future<dynamic> Function(bool)? initMediation;

  Future<void> handleRequestUmp({VoidCallback? onPostExecute}) async {
    if (_canRequestAds) {
      onPostExecute?.call();
      return;
    }
    if (EasyAds.instance.isDeviceOffline) {
      onPostExecute?.call();
      return;
    }
    final params = ConsentRequestParameters(
      consentDebugSettings: debugUmp ? _debugSettings : null,
    );

    bool? consentResult = await EasyAds.instance.getConsentResult();

    if (consentResult != null) {
      _canRequestAds = consentResult;

      if (_canRequestAds) {
        if (!_isMediationInitialized) {
          await initMediation?.call(_canRequestAds);
          _isMediationInitialized = true;
        }
        await EasyAds.instance.initAdNetwork();
      }
      onPostExecute?.call();
      return;
    }

    ///===========================================
    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          ///form available, try to show it
          _loadAndShowUmpForm(onPostExecute);
        } else {
          _canRequestAds = true;
          if (!_isMediationInitialized) {
            await initMediation?.call(_canRequestAds);
            _isMediationInitialized = true;
          }

          await EasyAds.instance.initAdNetwork();
          onPostExecute?.call();
        }
      },
      (FormError error) async {
        _canRequestAds = true;
        if (!_isMediationInitialized) {
          await initMediation?.call(_canRequestAds);
          _isMediationInitialized = true;
        }

        await EasyAds.instance.initAdNetwork();
        onPostExecute?.call();
      },
    );
  }

  void _loadAndShowUmpForm(VoidCallback? onPostExecute) {
    ConsentForm.loadConsentForm(
      (ConsentForm consentForm) async {
        //show the form
        var consentResult = await EasyAds.instance.getConsentResult();
        if (consentResult != null) {
          _canRequestAds = consentResult;
          if (!_isMediationInitialized) {
            await initMediation?.call(_canRequestAds);
            _isMediationInitialized = true;
          }
          if (_canRequestAds) {
            await EasyAds.instance.initAdNetwork();
          }

          onPostExecute?.call();
        } else {
          consentForm.show((formError) async {
            _canRequestAds = await EasyAds.instance.getConsentResult() ?? true;
            if (!_isMediationInitialized) {
              await initMediation?.call(_canRequestAds);
              _isMediationInitialized = true;
            }
            if (_canRequestAds) {
              await EasyAds.instance.initAdNetwork();
            }

            onPostExecute?.call();
          });
        }
      },
      (FormError formError) async {
        _canRequestAds = await EasyAds.instance.getConsentResult() ?? true;
        if (!_isMediationInitialized) {
          await initMediation?.call(_canRequestAds);
          _isMediationInitialized = true;
        }
        if (_canRequestAds) {
          await EasyAds.instance.initAdNetwork();
        }

        onPostExecute?.call();
      },
    );
  }
}
