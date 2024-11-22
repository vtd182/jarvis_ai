import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:jarvis_ai/modules/home/app/ui/chat/chat_page_viewmodel.dart';
import 'package:jarvis_ai/modules/home/app/ui/home_page_viewmodel.dart';
import 'package:jarvis_ai/modules/home/app/ui/setting/setting_page.dart';
import 'package:jarvis_ai/modules/home/domain/enums/assistant.dart';
import 'package:suga_core/suga_core.dart';

import '../../../../locator.dart';
import 'chat/chat_page.dart';

import 'package:jarvis_ai/modules/prompt/app/ui/prompt/prompt_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BaseViewState<HomePage, HomePageViewModel> {
  final List<Widget> _pages = [
    ChatPage(),
    PromptPage(),
    SettingPage(),
  ];

  void _onNavItemTapped(int index) {
    viewModel.selectedIndex = index;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Scaffold(
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
                              selectedIndex: viewModel.selectedIndex,
                              onTap: _onNavItemTapped,
                            ),
                            NavDrawerItem(
                              icon: Icons.edit,
                              label: "Write",
                              index: 1,
                              selectedIndex: viewModel.selectedIndex,
                              onTap: _onNavItemTapped,
                            ),
				              NavDrawerItem(
				                icon: Icons.edit,
				                label: "Prompt",
				                index: 2,
				                selectedIndex: viewModel.selectedIndex,
				                onTap: _onNavItemTapped,
				              ),
                            const Divider(height: 1, color: Colors.grey),
                            ...viewModel.conversationSummaries.map(
                              (item) => ListTile(
                                title: Text(item.title),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  locator<ChatPageViewModel>().conversationId = item.id;
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
                  index: 3,
                  selectedIndex: viewModel.selectedIndex,
                  onTap: _onNavItemTapped,
                ),
              ],
            ),
          ),
          body: _pages[viewModel.selectedIndex],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    if (viewModel.selectedIndex == 0) {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: DropdownButton<String>(
          value: viewModel.currentAssistant.value.label,
          items: viewModel.models.map((model) {
            return DropdownMenuItem(
              value: model.label,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(model.label),
                  if (model.label == viewModel.currentAssistant.value.label) const Icon(Icons.check, color: Colors.blue),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              viewModel.currentAssistant.value = viewModel.models.firstWhere(
                (model) => model.label == value,
              );
            }
          },
          underline: Container(),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {
              if (locator<ChatPageViewModel>().conversationId != null) {
                locator<ChatPageViewModel>().conversationId = null;
              }
            },
          ),
        ],
      );
    } else if (viewModel.selectedIndex == 1) {
      return AppBar(
        title: const Text("Write Page"),
      );
    } else {
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
