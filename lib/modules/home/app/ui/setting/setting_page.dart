import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/locator.dart';
import 'package:jarvis_ai/modules/auth/app/ui/login/login_page.dart';
import 'package:jarvis_ai/modules/home/app/ui/setting/setting_page_viewmodel.dart';
import 'package:suga_core/suga_core.dart';

import '../../../../../storage/spref.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends BaseViewState<SettingPage, SettingPageViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFF3F4F6),
        child: Column(
          children: [
            _buildSettingSection([
              _buildSettingItem(Icons.share, 'Share to friend', onTap: () => _onSettingItemTap('Share to friend')),
            ]),
            _buildSettingSection([
              _buildSettingItem(Icons.brightness_6, 'Theme', trailingText: 'Light mode', onTap: () => _onSettingItemTap('Theme')),
              _buildSettingItem(Icons.language, 'Language', onTap: () => _onSettingItemTap('Language')),
              _buildSettingItem(Icons.headset_mic, 'Feedback', onTap: () => _onSettingItemTap('Feedback')),
              _buildSettingItem(Icons.info_outline, 'About us', onTap: () => _onSettingItemTap('About us')),
            ]),
            _buildSettingSection([
              _buildSettingItem(Icons.account_circle, 'Account', onTap: () => _onSettingItemTap('Account')),
              _buildSettingItem(Icons.logout, 'Log out', onTap: () => _onSettingItemTap('Log out')),
            ]),
            const Spacer(),
            _buildVersionInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingSection(List<Widget> items) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: items
            .map((item) => Column(
                  children: [
                    item,
                    if (item != items.last) Divider(height: 1, color: Colors.grey.shade300),
                  ],
                ))
            .toList(),
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, {String? trailingText, required VoidCallback onTap}) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing:
          trailingText != null ? Text(trailingText, style: const TextStyle(color: Colors.grey)) : const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildVersionInfo() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Text('Version:1.0.0', style: TextStyle(color: Colors.grey, fontSize: 12)),
          Text('Design by @vtd182', style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Future<void> _onSettingItemTap(String title) async {
    // Thêm logic xử lý khi nhấn vào từng mục
    switch (title) {
      case 'Share to friend':
        // Thực hiện hành động chia sẻ
        print('Chia sẻ với bạn bè');
        break;
      case 'Theme':
        // Mở trang cài đặt chủ đề
        print('Chỉnh chủ đề');
        break;
      case 'Language':
        // Mở trang chỉnh kích thước font
        print('Language');
        break;
      case 'Feedback':
        // Mở trang phản hồi
        print('Gửi phản hồi');
        break;
      case 'About us':
        // Mở trang giới thiệu
        print('Giới thiệu về chúng tôi');
        break;
      case 'Account':
        // Mở trang tài khoản
        print('Cài đặt tài khoản');
        break;
      case 'Log out':
        await viewModel.signOut();
        SPref.instance.deleteAll();
        await Get.offAll(() => const LoginPage());
        break;
      default:
        break;
    }
  }

  @override
  SettingPageViewModel createViewModel() {
    return locator<SettingPageViewModel>();
  }
}
