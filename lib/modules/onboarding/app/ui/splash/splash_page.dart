import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/boarding/app/ui/splash/splash_page_view_model.dart';
import 'package:santapocket/modules/version/app/ui/notify_update_view.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends BaseViewState<SplashPage, SplashPageViewModel> {
  @override
  SplashPageViewModel createViewModel() => locator<SplashPageViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 5,
                ),
                child: Column(
                  children: <Widget>[
                    Assets.images.imgApp.image(
                      width: 263.w,
                      height: 118.h,
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                    const Spacer(),
                    Assets.images.imgSugaGroup.image(
                      width: 101.w,
                      height: 69.h,
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(
            () => Visibility(
              visible: viewModel.forceUpdate,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 80.h),
                  child: NotifyUpdateView(
                    image: AssetImage(Assets.icons.icSplashWarningUpdate.path),
                    // Assets.icons.icWarningUpdate,
                    text: LocaleKeys.boarding_notice_version_outdated.trans(),
                    color: AppTheme.voraciousWhite,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
