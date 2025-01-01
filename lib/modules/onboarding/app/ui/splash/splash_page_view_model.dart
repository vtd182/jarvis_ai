import 'dart:async';

import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/core/abstracts/app_view_model.dart';
import 'package:jarvis_ai/modules/auth/app/ui/login/login_page.dart';
import 'package:jarvis_ai/modules/auth/domain/events/session_expired_event.dart';
import 'package:jarvis_ai/modules/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:jarvis_ai/modules/home/app/ui/home_page.dart';
import 'package:suga_core/suga_core.dart' hide Oauth2Manager;

import '../../../../../helpers/string_helper.dart';
import '../../../../../storage/spref.dart';
import '../../../../auth/app/ui/widgets/session_expired_widget.dart';

@injectable
class SplashPageViewModel extends AppViewModel {
  final _forceUpdate = false.obs;

  bool get forceUpdate => _forceUpdate.value;

  StreamSubscription? _sessionExpiredEventListener;

  final RefreshTokenUseCase _refreshTokenUseCase;
  final EventBus _eventBus;
  SplashPageViewModel(
    this._eventBus,
    this._refreshTokenUseCase,
  );

  @override
  void initState() {
    _onInit();
    _sessionExpiredEventListener =
        _eventBus.on<SessionExpiredEvent>().listen((event) {
      Get.bottomSheet(
        const SessionExpiredWidget(),
        isDismissible: false,
        isScrollControlled: false,
        enableDrag: false,
        elevation: 1,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
      );
    });
    super.initState();
  }

  Future<Unit> _onInit() async {
    await loadData();
    return unit;
  }

  @override
  void disposeState() {
    _sessionExpiredEventListener?.cancel();
    super.disposeState();
  }

  Future<Unit> loadData() async {
    await Future.delayed(const Duration(seconds: 1));

    // await run(
    //   () async {
    //     await _clearUserCacheUsecase.run();
    //     user = await _getProfileUsecase.run();
    //   },
    // );

    final isAuth = await this.isAuth();
    EasyAds.instance.appLifecycleReactor?.setOnSplashScreen(false);

    if (!isAuth) {
      await Get.off(() => const LoginPage());
      return unit;
    }

    await Get.off(() => const HomePage());

    return unit;
  }

  Future<bool> isAuth() async {
    const timeRefreshBeforeExpire = 30;
    final String? accessToken = await SPref.instance.getAccessToken();
    if (StringHelper.isNullOrEmpty(accessToken)) {
      print("accessToken is null");
      return false;
    }
    final int? expiration = await SPref.instance.getExpiresAt();
    if (expiration != null) {
      if (DateTime.now().isAfter(DateTime.fromMillisecondsSinceEpoch(
          expiration - timeRefreshBeforeExpire))) {
        final String? refreshToken = await SPref.instance.getRefreshToken();
        if (StringHelper.isNullOrEmpty(refreshToken)) {
          print("refreshToken is null");
          return false;
        }

        final res = await _refreshTokenUseCase.run();
        return res;
      } else {
        return true;
      }
    } else {
      print("expiration is null");
      return false;
    }
  }
}
