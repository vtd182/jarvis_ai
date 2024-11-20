import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:jarvis_ai/modules/home/app/ui/home_page_viewmodel.dart';
import 'package:jarvis_ai/modules/home/app/ui/setting/setting_page.dart';
import 'package:suga_core/suga_core.dart';

import '../../../../locator.dart';
import 'chat/chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BaseViewState<HomePage, HomePageViewModel> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ChatPage(),
    WritePage(),
    SettingPage(),
  ];

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        drawer: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.grey,
                ),
                child: Center(
                  child: Obx(
                    () => Text(
                      "Token available: ${viewModel.tokenUsage.value.availableTokens}",
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await viewModel.getTokenUsage();
                  },
                  child: Obx(() => ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          // Nav Items
                          NavDrawerItem(
                            icon: Icons.chat,
                            label: "Chat",
                            index: 0,
                            selectedIndex: _selectedIndex,
                            onTap: _onNavItemTapped,
                          ),
                          NavDrawerItem(
                            icon: Icons.edit,
                            label: "Write",
                            index: 1,
                            selectedIndex: _selectedIndex,
                            onTap: _onNavItemTapped,
                          ),
                          const Divider(height: 1, color: Colors.grey),
                          ...viewModel.conversationSummaries.map(
                            (item) => ListTile(
                              title: Text(item.title),
                              onTap: () {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Bạn đã nhấn vào: ${item.title}")),
                                );
                              },
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              NavDrawerItem(
                icon: Icons.settings,
                label: "Settings",
                index: 2,
                selectedIndex: _selectedIndex,
                onTap: _onNavItemTapped,
              ),
            ],
          ),
        ),
        body: _pages[_selectedIndex],
      ),
    );
  }

  AppBar _buildAppBar() {
    // Tuỳ chỉnh AppBar theo từng page
    if (_selectedIndex == 0) {
      // AppBar của ChatPage
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Chat với AI",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          // Dropdown chọn AI model
          DropdownButton<String>(
            value: "GPT-3", // Dữ liệu mẫu
            items: ["GPT-3", "GPT-4", "Bard", "Claude"].map((model) {
              return DropdownMenuItem(
                value: model,
                child: Text(model),
              );
            }).toList(),
            onChanged: (value) {
              // Xử lý khi chọn model
            },
            underline: Container(),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {
              // Xử lý nút thêm mới
            },
          ),
        ],
      );
    } else if (_selectedIndex == 1) {
      // AppBar của WritePage
      return AppBar(
        title: const Text("Write Page"),
      );
    } else {
      // AppBar của SettingPage
      return AppBar(
        title: const Text("Settings"),
      );
    }
  }

  @override
  HomePageViewModel createViewModel() {
    return locator<HomePageViewModel>();
  }
}

class NavDrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int selectedIndex;
  final Function(int) onTap;

  const NavDrawerItem({
    super.key,
    required this.icon,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: index == selectedIndex ? Colors.blue : Colors.grey),
      title: Text(
        label,
        style: TextStyle(color: index == selectedIndex ? Colors.blue : Colors.grey),
      ),
      selected: index == selectedIndex,
      onTap: () => onTap(index),
    );
  }
}

class WritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Write Page"));
  }
}
