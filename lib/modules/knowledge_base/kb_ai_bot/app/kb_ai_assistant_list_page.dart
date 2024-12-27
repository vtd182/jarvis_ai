import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:jarvis_ai/helpers/ui_helper.dart';
import 'package:jarvis_ai/locator.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/app/kb_ai_assistant_list_page_viewmodel.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/app/widgets/kb_ai_assistant_item_view.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:suga_core/suga_core.dart';

class KBAIAssistantListPage extends StatefulWidget {
  const KBAIAssistantListPage({super.key});

  @override
  State<KBAIAssistantListPage> createState() => _KBAIAssistantListPageState();
}

class _KBAIAssistantListPageState extends BaseViewState<KBAIAssistantListPage, KBAIAssistantListPageViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await viewModel.showCreateAssistantDialog();
        },
        child: const Icon(Icons.add),
      ),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: () async {
            print("Refresh");
          },
          child: NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo.metrics.maxScrollExtent > 0) {
                  final isAtBottom = scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent;
                  if (isAtBottom && viewModel.isHasNext) {
                    showToast("loading more");
                  }
                }
                return false;
              },
              child: _buildGrid()),
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return ResponsiveGridList(
      desiredItemWidth: 300,
      minSpacing: 16,
      children: [
        for (final item in viewModel.kBAIAssistantList)
          KBAIAssistantItemView(
            assistant: item,
            onDelete: () {
              print("Delete");
            },
            onFavoriteTap: () {
              print("Favorite");
            },
            onItemTap: () {
              print("Item Tap");
            },
          )
      ],
    );
  }

  @override
  KBAIAssistantListPageViewModel createViewModel() {
    return locator<KBAIAssistantListPageViewModel>();
  }
}
