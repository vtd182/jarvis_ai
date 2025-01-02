import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/extensions/context_ext.dart';
import 'package:jarvis_ai/modules/home/app/ui/chat/chat_page_viewmodel.dart';
import 'package:jarvis_ai/modules/prompt/app/ui/prompt/prompt_view_model.dart';
import 'package:jarvis_ai/modules/prompt/app/ui/widget/use_prompt_bottom_sheet.dart';
import 'package:jarvis_ai/modules/shared/theme/app_theme.dart';

import '../../../../../locator.dart';
import '../../../../home/app/ui/home_page_viewmodel.dart';

class PublicPromptTabViewItem extends StatefulWidget {
  const PublicPromptTabViewItem({super.key});

  @override
  State<PublicPromptTabViewItem> createState() => _PublicPromptTabViewItemState();
}

class _PublicPromptTabViewItemState extends State<PublicPromptTabViewItem> {
  final controller = Get.find<PromptViewModel>();
  final _publicSearchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    controller.isFetchingNewData.value = false;
    controller.getPublicPrompt(query: "");
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    /// end of list listener
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.getPublicPrompt(query: _publicSearchController.text, isLoadMore: true);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _publicSearchController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    fillColor: AppTheme.grey,
                    filled: true,
                    suffixIcon: IconButton(
                      onPressed: () {
                        context.hideKeyboard();
                        controller.getPublicPrompt(
                          query: _publicSearchController.text,
                        );
                      },
                      icon: const Icon(
                        Icons.search,
                        color: AppTheme.primaryBlue,
                        size: 22,
                      ),
                    ),
                    hintText: "Search",
                    hintStyle: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.greyText, fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  controller.isGetFavorite.value = !controller.isGetFavorite.value;
                  controller.getPublicPrompt(
                    query: _publicSearchController.text,
                  );
                },
                child: Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.greyText,
                    ),
                  ),
                  child: Obx(
                    () => Icon(
                      Icons.favorite,
                      color: controller.isGetFavorite.value ? Colors.red : Colors.grey,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 30,
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(width: 8);
              },
              scrollDirection: Axis.horizontal,
              itemCount: controller.listPromptCategory.length,
              itemBuilder: (context, index) {
                return Obx(() {
                  return InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () {
                      controller.indexCategory.value = index;
                      controller.getPublicPrompt(
                        query: _publicSearchController.text,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: controller.indexCategory.value == index ? AppTheme.primaryBlue : AppTheme.grey,
                      ),
                      child: Text(
                        controller.listPromptCategory[index],
                        style: TextStyle(
                            color: controller.indexCategory.value == index ? Colors.white : Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => controller.isLoading.value
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Expanded(
                    child: controller.listPrompt.isEmpty
                        ? const Center(child: Text("No prompts found 🥺. Try another or make your prompt"))
                        : Obx(
                            () => ListView.separated(
                              controller: _scrollController,
                              itemBuilder: (context, index) {
                                if (index == controller.listPrompt.length) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                final item = controller.listPrompt[index];
                                return InkWell(
                                  onTap: () {
                                    Get.bottomSheet(
                                      UsePromptBottomSheet(
                                        promptItem: item,
                                        onMessageSent: (message) {
                                          locator<HomePageViewModel>().selectedIndex = 0;
                                          locator<ChatPageViewModel>().sendMessage(message);
                                        },
                                      ),
                                      isScrollControlled: true,
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              "${item.title}",
                                              style: AppTheme.black_14w600,
                                            ),
                                            Text(
                                              "${item.description}",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: AppTheme.greyText,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: Icon(
                                          item.isFavorite == true ? Icons.favorite : Icons.favorite_border,
                                          color: item.isFavorite == true ? Colors.red : AppTheme.greyText,
                                        ),
                                        onPressed: () {
                                          controller.toggleFavoritePrompt(id: item.id!);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                              itemCount: controller.listPrompt.length + (controller.isFetchingNewData.value ? 1 : 0),
                            ),
                          ),
                  ),
          ),
        ],
      ),
    );
  }
}
