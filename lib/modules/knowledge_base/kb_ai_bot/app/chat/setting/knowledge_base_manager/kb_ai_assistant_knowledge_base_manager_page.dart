import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/locator.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/app/chat/setting/knowledge_base_manager/kb_ai_assistant_knowledge_base_manager_page_viewmodel.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/app/chat/setting/knowledge_base_manager/widgets/knowledge_base_empty_import.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/app/chat/setting/knowledge_base_manager/widgets/knowledge_base_item_view.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_knowledge.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:suga_core/suga_core.dart';

class KBAIAssistantKnowledgeBaseManagerPage extends StatefulWidget {
  final String assistantId;

  const KBAIAssistantKnowledgeBaseManagerPage({super.key, required this.assistantId});

  @override
  State<KBAIAssistantKnowledgeBaseManagerPage> createState() => _KBAIAssistantKnowledgeBaseManagerPageState();
}

class _KBAIAssistantKnowledgeBaseManagerPageState
    extends BaseViewState<KBAIAssistantKnowledgeBaseManagerPage, KBAIAssistantKnowledgeBaseManagerPageViewModel> {
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  loadArguments() {
    viewModel.assistantId.value = widget.assistantId;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        floatingActionButton: viewModel.kBAIKnowledgeImportedList.isEmpty
            ? null
            : FloatingActionButton(
                onPressed: () async {
                  viewModel.showImportDialog();
                },
                child: const Icon(Icons.add),
              ),
        appBar: AppBar(
          title: const Text("Knowledge Base Manager"),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await viewModel.onRefresh();
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.maxScrollExtent > 0) {
                final isAtBottom = scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent;
                if (isAtBottom && viewModel.isHasNext && !viewModel.isLoadingMore) {
                  viewModel.onLoadingMore();
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
                  child: viewModel.kBAIKnowledgeImportedList.isEmpty
                      ? KnowledgeBaseEmptyImport(
                          onImport: () async {
                            viewModel.showImportDialog();
                          },
                        )
                      : _buildGrid(),
                ),
              ],
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
      desiredItemWidth: 300,
      minSpacing: 16,
      children: [
        for (final item in viewModel.kBAIKnowledgeImportedList)
          KnowledgeBaseItemView<KBAIKnowledge>(
            onDelete: () async {
              await viewModel.onShowConfirmDeleteDialog(item.id);
            },
            onImportTap: null,
            onItemTap: () {},
            openItemIdNotifier: viewModel.openItemIdNotifier,
            item: item,
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
    viewModel.query = query;
    _debounce = Timer(
      const Duration(seconds: 1),
      () {
        viewModel.onSearch(query);
      },
    );
  }

  @override
  KBAIAssistantKnowledgeBaseManagerPageViewModel createViewModel() {
    return locator<KBAIAssistantKnowledgeBaseManagerPageViewModel>();
  }
}
