import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/extensions/string_ext.dart';
import 'package:jarvis_ai/gen/assets.gen.dart';
import 'package:jarvis_ai/locale_keys.g.dart';
import 'package:jarvis_ai/modules/auth/app/ui/login/login_page.dart';

import '../../../../shared/theme/app_theme.dart';

class SessionExpiredWidget extends StatelessWidget {
  const SessionExpiredWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 30.h,
          ),
          Assets.images.imgExpiredTimeBackground.image(
            width: 212.w,
            height: 97.h,
          ),
          SizedBox(
            height: 18.h,
          ),
          Text(
            "Oops!",
            style: AppTheme.red_16w700,
          ),
          SizedBox(
            height: 9.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 35.w),
            child: Text(
              LocaleKeys.auth_notify_session_expired.trans(),
              style: AppTheme.blackDark_16w400,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 26.h,
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.off(() => const LoginPage());
            },
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              backgroundColor: AppTheme.orange,
              minimumSize: Size(300.w, 50.h),
              padding: EdgeInsets.symmetric(vertical: 14.h),
            ),
            child: Text(
              LocaleKeys.auth_got_it.trans(),
              style: AppTheme.white_16w600,
            ),
          ),
          SizedBox(
            height: 18.h,
          ),
        ],
      ),
    );
  }
}
