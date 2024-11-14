import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/modules/auth/app/ui/login/enter_phone_page.dart';
import 'package:santapocket/modules/auth/app/ui/widgets/session_expired_widget.dart';
import 'package:santapocket/modules/auth/domain/events/session_expired_event.dart';
import 'package:santapocket/modules/main/app/ui/main_page.dart';
import 'package:santapocket/modules/system_maintenance/app/ui/system_maintenance_page.dart';
import 'package:santapocket/modules/system_maintenance/domain/models/system_maintenance.dart';
import 'package:santapocket/modules/system_maintenance/domain/usecases/get_running_system_maintenance_usecase.dart';
import 'package:santapocket/modules/user/app/ui/wizard/wizard_profile_page.dart';
import 'package:santapocket/modules/user/app/ui/wizard/wizard_profile_select_type_page.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/usecases/clear_user_cache_usecase.dart';
import 'package:santapocket/modules/user/domain/usecases/get_profile_usecase.dart';
import 'package:santapocket/modules/version/domain/enums/version_status.dart';
import 'package:santapocket/modules/version/domain/usecases/get_version_status_usecase.dart';
import 'package:santapocket/oauth2/oauth2_manager.dart';
import 'package:suga_core/suga_core.dart' hide Oauth2Manager;

@injectable
class SplashPageViewModel extends AppViewModel {
  final _forceUpdate = false.obs;

  bool get forceUpdate => _forceUpdate.value;

  StreamSubscription? _sessionExpiredEventListener;

  final GetProfileUsecase _getProfileUsecase;
  final GetVersionStatusUsecase _getVersionStatusUsecase;
  final ClearUserCacheUsecase _clearUserCacheUsecase;
  final EventBus _eventBus;
  final GetRunningSystemMaintenanceUsecase _getRunningSystemMaintenanceUsecase;

  SplashPageViewModel(
    this._getProfileUsecase,
    this._getVersionStatusUsecase,
    this._clearUserCacheUsecase,
    this._eventBus,
    this._getRunningSystemMaintenanceUsecase,
  );

  @override
  void initState() {
    _onInit();
    _sessionExpiredEventListener = _eventBus.on<SessionExpiredEvent>().listen((event) {
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

    User? user;
    VersionStatus versionStatus = VersionStatus.unknown;
    SystemMaintenance? runningSystemMaintenance;

    await run(() async {
      runningSystemMaintenance = await _getRunningSystemMaintenanceUsecase.run();
    });

    if (runningSystemMaintenance != null) {
      await Get.offAll(() => SystemMaintenancePage(runningSystemMaintenance: runningSystemMaintenance!));
      return unit;
    }

    await run(
      () async {
        await _clearUserCacheUsecase.run();
        user = await _getProfileUsecase.run();
        versionStatus = await _getVersionStatusUsecase.run();
      },
    );

    if (versionStatus == VersionStatus.outdated) {
      _forceUpdate.value = true;
      return unit;
    }

    final isAuth = await Oauth2Manager.instance.checkAuth();
    if (!isAuth) {
      await Get.off(() => const EnterPhonePage());
      return unit;
    }

    if (user?.shouldWizardName ?? false) {
      await Get.off(() => WizardProfilePage(username: user?.name));
      return unit;
    }

    if (user?.shouldWizardType ?? false) {
      await Get.off(() => const WizardProfileSelectTypePage(
            isFirstLogin: false,
          ));
      return unit;
    }
    await Get.off(() => const MainPage());

    return unit;
  }
}
