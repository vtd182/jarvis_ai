import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jarvis_ai/main.dart';

void main() {
  testWidgets('App builds successfully without exceptions', (WidgetTester tester) async {
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

    // Nếu đến đây mà không có exception, nghĩa là app build thành công
    expect(find.byType(Main), findsOneWidget);
  });
}
