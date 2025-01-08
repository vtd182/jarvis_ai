import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/response_get_kl.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/app/chat/setting/knowledge_base_manager/kb_ai_assistant_knowledge_base_manager_page_viewmodel.dart';
import 'package:responsive_grid/responsive_grid.dart';

import 'knowledge_base_empty_import.dart';
import 'knowledge_base_item_view.dart';

class KnowledgeBaseListForImport extends StatefulWidget {
  KBAIAssistantKnowledgeBaseManagerPageViewModel viewModel;
  KnowledgeBaseListForImport({super.key, required this.viewModel});

  @override
  State<KnowledgeBaseListForImport> createState() => _KnowledgeBaseListForImportState();
}

class _KnowledgeBaseListForImportState extends State<KnowledgeBaseListForImport> {
  KBAIAssistantKnowledgeBaseManagerPageViewModel get viewModel => widget.viewModel;
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        padding: const EdgeInsets.all(10),
        child: Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              await viewModel.onBottomSheetRefresh();
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo.metrics.maxScrollExtent > 0) {
                  final isAtBottom = scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent;
                  if (isAtBottom && viewModel.bottomSheetIsHasNext && !viewModel.bottomSheetIsLoadingMore) {
                    viewModel.onBottomSheetLoadingMore();
                  }
                }
                return false;
              },
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildSearchAndFilterBar(),
                  const SizedBox(height: 16),
                  Expanded(
                    child: viewModel.kBAIKnowledgeList.isEmpty
                        ? KnowledgeBaseEmptyImport(
                            onImport: () async {
                              print("Import");
                            },
                          )
                        : _buildGrid(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildSearchField(),
          ),
          // const SizedBox(width: 16),
          // CupertinoButton(
          //   onPressed: () {
          //     print("Filter");
          //   },
          //   child: const Icon(Icons.filter_list),
          // ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return ResponsiveGridList(
      physics: const AlwaysScrollableScrollPhysics(),
      desiredItemWidth: 300,
      minSpacing: 16,
      children: [
        for (final item in viewModel.kBAIKnowledgeList)
          KnowledgeBaseItemView<ResponseGetKl>(
            onDelete: () async {},
            onItemTap: () {},
            openItemIdNotifier: viewModel.openItemIdNotifier,
            item: item,
            enableSwipeToDelete: false,
            onImportTap: () {
              viewModel.importKnowledgeToAssistant(item.id);
            },
            importState: viewModel.itemImportStates[item.id] ?? ImportState.idle,
          )
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      width: double.infinity,
      height: 40.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.search, color: Colors.grey),
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                hintText: "Search",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    viewModel.bottomSheetQuery = query;
    _debounce = Timer(
      const Duration(seconds: 1),
      () {
        viewModel.onBottomSheetSearch(query);
      },
    );
  }
}
