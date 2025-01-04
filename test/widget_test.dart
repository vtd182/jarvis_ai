import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jarvis_ai/loading.dart';
import 'package:jarvis_ai/locator.dart';
import 'package:jarvis_ai/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    // Khởi tạo giá trị mock cho SharedPreferences
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    await setupLocator();
    setupEasyLoading();
  });

  tearDownAll(() {
    // Hủy bỏ tất cả các dịch vụ trong locator
    locator.reset();
  });

  testWidgets('App builds successfully without exceptions', (WidgetTester tester) async {
    // Sử dụng FakeAsync để kiểm soát Timer
    await tester.runAsync(() async {
      await tester.pumpWidget(
        EasyLocalization(
          supportedLocales: const [Locale('en'), Locale('vi')],
          path: 'assets/langs',
          useOnlyLangCode: true,
          fallbackLocale: const Locale('en'),
          child: ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (context, child) => const Main(),
          ),
        ),
      );

      // Đợi tất cả các frame được vẽ
      await tester.pumpAndSettle();

      // Kiểm tra xem widget Main có xuất hiện không
      expect(find.byType(Main), findsOneWidget);
    });
  });
}
