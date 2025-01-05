import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:jarvis_ai/modules/email/app/ui/email_page.dart';
import 'package:jarvis_ai/modules/home/app/ui/account_upgrade_page.dart';
import 'package:jarvis_ai/modules/home/app/ui/chat/chat_page_viewmodel.dart';
import 'package:jarvis_ai/modules/home/app/ui/home_page_viewmodel.dart';
import 'package:jarvis_ai/modules/home/app/ui/setting/setting_page.dart';
import 'package:jarvis_ai/modules/home/domain/enums/assistant.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/page/knowledge_page.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/app/kb_ai_assistant_list_page.dart';
import 'package:jarvis_ai/modules/prompt/app/ui/prompt/prompt_page.dart';
import 'package:suga_core/suga_core.dart';

import '../../../../locator.dart';
import 'chat/chat_page.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/HomePage";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BaseViewState<HomePage, HomePageViewModel> {
  final List<Widget> _pages = [
    const ChatPage(),
    PromptPage(),
    const KBAIAssistantListPage(),
    KnowledgePage(),
    SettingPage(),
    const EmailPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Scaffold(
          appBar: _buildAppBar(),
          drawer: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width * 0.75,
            child: Column(
              children: [
                _buildAccountInformation(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await viewModel.onRefreshDrawer();
                    },
                    child: Obx(
                      () => ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: 6 + viewModel.conversationSummaries.length, // 5 items + history count
                        itemBuilder: (context, index) {
                          if (index < 6) {
                            // Render NavDrawerItem
                            return _buildNavDrawerItem(index);
                          } else {
                            // Render History Items
                            final item = viewModel.conversationSummaries[index - 6];
                            return _buildItemList(
                              title: item.title,
                              onTap: () {
                                Navigator.of(context).pop();
                                if (viewModel.selectedIndex != 0) {
                                  viewModel.onNavItemTapped(0);
                                }
                                locator<ChatPageViewModel>().conversationId = item.id;
                              },
                              isSelected: viewModel.selectedIndex == 0 && locator<ChatPageViewModel>().conversationId == item.id,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                NavDrawerItem(
                  icon: Icons.settings,
                  label: "Settings",
                  index: 4,
                  onTap: viewModel.onNavItemTapped,
                  isSelected: viewModel.selectedIndex == 4,
                ),
              ],
            ),
          ),
          body: _pages[viewModel.selectedIndex],
        ),
      ),
    );
  }

  Widget _buildNavDrawerItem(int index) {
    final navItems = [
      NavDrawerItem(
        icon: Icons.chat,
        label: "Chat",
        index: 0,
        onTap: viewModel.onNavItemTapped,
        isSelected: viewModel.selectedIndex == 0 && locator<ChatPageViewModel>().conversationId == null,
      ),
      NavDrawerItem(
        icon: Icons.edit,
        label: "Prompt",
        index: 1,
        onTap: viewModel.onNavItemTapped,
        isSelected: viewModel.selectedIndex == 1,
      ),
      NavDrawerItem(
        icon: Icons.add_home_outlined,
        label: "Personal Assistant",
        index: 2,
        onTap: viewModel.onNavItemTapped,
        isSelected: viewModel.selectedIndex == 2,
      ),
      NavDrawerItem(
        icon: Icons.library_books,
        label: "Knowledge",
        index: 3,
        onTap: viewModel.onNavItemTapped,
        isSelected: viewModel.selectedIndex == 3,
      ),
      NavDrawerItem(
        icon: Icons.email,
        label: "Email",
        index: 5,
        onTap: viewModel.onNavItemTapped,
        isSelected: viewModel.selectedIndex == 5,
      ),
      const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: 0,
              thickness: 1.2,
              color: Colors.grey,
            ),
          ),
          ListTile(
            title: Text(
              "History",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    ];
    return navItems[index];
  }

  Widget _buildItemList({
    required String title,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return Container(
      color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  AppBar _buildAppBar() {
    switch (viewModel.selectedIndex) {
      case 0:
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
                    const SizedBox(width: 8),
                    if (model.label == viewModel.currentAssistant.value.label)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.blue,
                        size: 18,
                      ),
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
      case 1:
        return AppBar(
          title: const Text("Prompt Library"),
          centerTitle: true,
        );
      case 2:
        return AppBar(
          title: const Text("Personal Assistant"),
          centerTitle: true,
        );
      case 3:
        return AppBar(
          title: const Text("Knowledge Library"),
          centerTitle: true,
        );
      case 4:
        return AppBar(
          title: const Text("Settings"),
          centerTitle: true,
        );
      case 5:
        return AppBar(
          title: const Text("Email Helper"),
          centerTitle: true,
        );
      default:
        return AppBar();
    }
  }

  Widget _buildAccountInformation() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  child: const Icon(Icons.person, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        viewModel.currentUser.value.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        viewModel.currentUser.value.email,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Token Usage 🔥',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Obx(() => Text(
                    "${viewModel.tokenUsage.value.unlimited ? "∞" : viewModel.tokenUsage.value.availableTokens}/${viewModel.tokenUsage.value.unlimited ? "∞" : viewModel.tokenUsage.value.totalTokens}",
                    style: const TextStyle(fontSize: 14))),
              ],
            ),
            const SizedBox(height: 8),
            Obx(() => LinearProgressIndicator(
                  value: viewModel.tokenUsage.value.unlimited
                      ? 1.0
                      : viewModel.tokenUsage.value.availableTokens / viewModel.tokenUsage.value.totalTokens,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                )),
            const SizedBox(height: 8),
            //Account type indicator
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PricingPage()));
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: viewModel.subscriptionUsage.value.annually > 0
                      ? Colors.yellowAccent
                      : (viewModel.subscriptionUsage.value.monthly > 0 ? Colors.green : Colors.blue),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    viewModel.subscriptionUsage.value.name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    return RefreshIndicator(
      onRefresh: () async {
        await viewModel.onRefreshDrawer();
      },
      child: Obx(
        () => NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (scrollInfo.metrics.maxScrollExtent > 0) {
              final isAtBottom = scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent;
              if (isAtBottom && !viewModel.isLoadingMore) {
                // todo: add loadmore
              }
            }
            return false;
          },
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: viewModel.conversationSummaries.length,
            itemBuilder: (context, index) {
              final item = viewModel.conversationSummaries[index];
              return _buildItemList(
                title: item.title,
                onTap: () {
                  Navigator.of(context).pop();
                  if (viewModel.selectedIndex != 0) {
                    viewModel.onNavItemTapped(0);
                  }
                  locator<ChatPageViewModel>().conversationId = item.id;
                },
                isSelected: viewModel.selectedIndex == 0 && locator<ChatPageViewModel>().conversationId == item.id,
              );
            },
          ),
        ),
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
  final bool isSelected;
  final Function(int) onTap;

  const NavDrawerItem({
    super.key,
    required this.icon,
    required this.label,
    required this.index,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
        title: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        selected: isSelected,
        onTap: () => onTap(index),
      ),
    );
  }
}
