import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/ads/remote_config.dart';
import 'package:jarvis_ai/gen/assets.gen.dart';
import 'package:jarvis_ai/locator.dart';
import 'package:jarvis_ai/main.dart';
import 'package:jarvis_ai/modules/onboarding/app/ui/splash/splash_page_view_model.dart';
import 'package:suga_core/suga_core.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends BaseViewState<SplashPage, SplashPageViewModel> {
  @override
  SplashPageViewModel createViewModel() => locator<SplashPageViewModel>();

  bool _initialized = false;

  @override
  void initState() {
    RemoteConfig.init().then((_) {
      RemoteConfig.getRemoteConfig();
      _initAdsModule();
    });
    super.initState();
  }

  Future<void> _initAdsModule() async {
    try {
      await EasyAds.instance.initialize(
        adIdManager,
        navigatorKey: Get.key,
        isDevMode: appFlavor != "prod",
        adMobAdRequest: const AdRequest(httpTimeoutMillis: 30000),
        admobConfiguration: RequestConfiguration(testDeviceIds: ['']),
        adResumeId: adIdManager.open_resume,
        adResumeConfig: RemoteConfig.open_resume,
        onInitialized: (bool canRequestAds) {
          if (canRequestAds) {
            setState(() {
              _initialized = true;
            });
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

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
                    Assets.images.imgLogoJarvis.image(
                      width: 263.w,
                      height: 118.h,
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                    const Spacer(),
                    const Text("Group 7"),
                    SizedBox(
                      height: 40.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
