import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/ads/event_log.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/page/knowledge_view_model.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/widget/kl_item.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/widget/search_kl_widget.dart';
import 'package:jarvis_ai/modules/shared/theme/app_theme.dart';

class ListKlWidget extends StatefulWidget {
  const ListKlWidget({super.key});

  @override
  State<ListKlWidget> createState() => _ListKlWidgetState();
}

class _ListKlWidgetState extends State<ListKlWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    EventLog.logEvent("knowledge_page");
    controller.getAllKnowledge();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    /// end of list listener
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.getAllKnowledge(query: controller.searchController.text, isLoadMore: true);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final controller = Get.find<KnowledgeViewModel>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SearchKlWidget(),
          const SizedBox(height: 12),
          Obx(
            () => controller.isLoading.value
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Expanded(
                    child: ListView.separated(
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        // LOAD MORE
                        if (index == controller.listKnowledge.length + 1) {
                          if (controller.hasNext.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }
                        if (index == 0) {
                          // HEADER
                          return Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  "Knowledge",
                                  style: AppTheme.black_14w600.copyWith(color: AppTheme.primaryBlue),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  "Units",
                                  style: AppTheme.black_14w600.copyWith(color: AppTheme.primaryBlue),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  "Size",
                                  style: AppTheme.black_14w600.copyWith(color: AppTheme.primaryBlue),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  "Action",
                                  style: AppTheme.black_14w600.copyWith(color: AppTheme.primaryBlue),
                                ),
                              ),
                            ],
                          );
                        }
                        // ITEM
                        final item = controller.listKnowledge[index - 1];
                        return KlItem(kl: item);
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: AppTheme.greyText.withOpacity(0.3),
                        );
                      },
                      itemCount: controller.listKnowledge.length + 2,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
