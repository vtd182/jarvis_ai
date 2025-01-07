import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/locator.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/app/kb_ai_assistant_list_page_viewmodel.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/app/widgets/kb_ai_assistant_item_view.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:suga_core/suga_core.dart';

import 'chat/kb_ai_assistant_chat_page.dart';

class KBAIAssistantListPage extends StatefulWidget {
  const KBAIAssistantListPage({super.key});

  @override
  State<KBAIAssistantListPage> createState() => _KBAIAssistantListPageState();
}

class _KBAIAssistantListPageState extends BaseViewState<KBAIAssistantListPage, KBAIAssistantListPageViewModel> {
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  final ScrollController _scrollController = ScrollController();
  bool _isFabVisible = true; // Trạng thái hiển thị FAB

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      // Nếu trượt xuống thì ẩn FAB
      if (_isFabVisible) {
        setState(() {
          _isFabVisible = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      // Nếu trượt lên thì hiển thị FAB
      if (!_isFabVisible) {
        setState(() {
          _isFabVisible = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _isFabVisible
          ? FloatingActionButton(
              onPressed: () async {
                await viewModel.showCreateAssistantDialog();
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: Obx(
        () => RefreshIndicator(
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
                  child: _buildGrid(),
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
          const SizedBox(width: 16),
          Obx(
            () => DropdownButton<FilterType>(
              value: viewModel.isFavorite == true
                  ? FilterType.favorite
                  : viewModel.isPublished == true
                      ? FilterType.published
                      : FilterType.all,
              onChanged: (filterType) {
                if (filterType != null) {
                  viewModel.onApplyFilter(filterType);
                }
              },
              items: FilterType.values.map((filterType) {
                return DropdownMenuItem<FilterType>(
                  value: filterType,
                  child: Text(filterType.label),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return ResponsiveGridList(
      controller: _scrollController,
      desiredItemWidth: 300,
      minSpacing: 16,
      children: [
        for (final item in viewModel.kBAIAssistantList)
          KBAIAssistantItemView(
            assistant: item,
            onDelete: () async {
              await viewModel.showDeleteAssistantDialog(item);
            },
            onFavoriteTap: () async {
              await viewModel.favoriteAssistant(item);
            },
            onEditTap: () async {
              await viewModel.showUpdateAssistantDialog(item);
            },
            onItemTap: () {
              Get.to(
                () => KBAIAssistantChatPage(
                  assistantId: item.id,
                ),
              );
            },
            openItemIdNotifier: viewModel.openItemIdNotifier,
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
              autofocus: true,
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
  KBAIAssistantListPageViewModel createViewModel() {
    return locator<KBAIAssistantListPageViewModel>();
  }
}
