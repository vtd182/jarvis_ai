import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:jarvis_ai/modules/home/app/ui/home_page_viewmodel.dart';
import 'package:jarvis_ai/modules/home/app/ui/setting/setting_page.dart';
import 'package:suga_core/suga_core.dart';

import '../../../../locator.dart';

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
    TranslatePage(),
    SearchPage(),
    OCRPage(),
    GrammarPage(),
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
        appBar: AppBar(),
        drawer: Drawer(
          child: RefreshIndicator(
            onRefresh: () async {
              await viewModel.getTokenUsage();
            },
            child: ListView(
              padding: EdgeInsets.zero,
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
                NavDrawerItem(
                  icon: Icons.translate,
                  label: "Translate",
                  index: 2,
                  selectedIndex: _selectedIndex,
                  onTap: _onNavItemTapped,
                ),
                NavDrawerItem(
                  icon: Icons.search,
                  label: "Search",
                  index: 3,
                  selectedIndex: _selectedIndex,
                  onTap: _onNavItemTapped,
                ),
                NavDrawerItem(
                  icon: Icons.camera,
                  label: "OCR",
                  index: 4,
                  selectedIndex: _selectedIndex,
                  onTap: _onNavItemTapped,
                ),
                NavDrawerItem(
                  icon: Icons.spellcheck,
                  label: "Grammar",
                  index: 5,
                  selectedIndex: _selectedIndex,
                  onTap: _onNavItemTapped,
                ),
                const Divider(height: 1, color: Colors.grey),
                NavDrawerItem(
                  icon: Icons.settings,
                  label: "Settings",
                  index: 6,
                  selectedIndex: _selectedIndex,
                  onTap: _onNavItemTapped,
                ),
              ],
            ),
          ),
        ),
        body: _pages[_selectedIndex],
      ),
    );
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

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Chat Page"));
  }
}

class WritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Write Page"));
  }
}

class TranslatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Translate Page"));
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Search Page"));
  }
}

class OCRPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("OCR Page"));
  }
}

class GrammarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Grammar Page"));
  }
}
