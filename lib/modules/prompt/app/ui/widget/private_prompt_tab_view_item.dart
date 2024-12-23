import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/extensions/context_ext.dart';
import 'package:jarvis_ai/modules/home/app/ui/home_page_viewmodel.dart';
import 'package:jarvis_ai/modules/prompt/app/ui/prompt/prompt_view_model.dart';
import 'package:jarvis_ai/modules/prompt/app/ui/widget/confirm_delete_prompt_dialog.dart';
import 'package:jarvis_ai/modules/prompt/app/ui/widget/create_private_prompt_dialog.dart';
import 'package:jarvis_ai/modules/prompt/app/ui/widget/use_prompt_bottom_sheet.dart';
import 'package:jarvis_ai/modules/shared/theme/app_theme.dart';

import '../../../../../locator.dart';
import '../../../../home/app/ui/chat/chat_page_viewmodel.dart';

class PrivatePromptTabViewItem extends StatefulWidget {
  const PrivatePromptTabViewItem({super.key});

  @override
  State<PrivatePromptTabViewItem> createState() =>
      _PrivatePromptTabViewItemState();
}

class _PrivatePromptTabViewItemState extends State<PrivatePromptTabViewItem> {
  final controller = Get.find<PromptViewModel>();

  final _privateSearchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    print("tpoo init private");
    controller.isFetchingNewData.value = false;
    controller.getPrivatePrompt();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    /// end of list listener
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.getPrivatePrompt(
            query: _privateSearchController.text, isLoadMore: true);
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
                  controller: _privateSearchController,
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
                        controller.getPrivatePrompt(
                          query: _privateSearchController.text,
                        );
                      },
                      icon: const Icon(
                        Icons.search,
                        color: AppTheme.primaryBlue,
                        size: 22,
                      ),
                    ),
                    hintText: "Search",
                    hintStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.greyText,
                        fontSize: 14),
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
              GestureDetector(
                onTap: () {
                  Get.dialog(CreatePrivatePromptDialog());
                },
                child: Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: AppTheme.primaryLinearGradient),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Obx(
            () => controller.isLoading.value
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Expanded(
                    child: controller.listPrompt.isEmpty
                        ? const Center(
                            child: Text(
                                "No prompts found 🥺. Try another or make your prompt"))
                        : ListView.separated(
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
                                        locator<HomePageViewModel>()
                                            .selectedIndex = 0;
                                        locator<ChatPageViewModel>()
                                            .sendMessage(message);
                                      },
                                    ),
                                    isScrollControlled: true,
                                  );
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        "${item.title}",
                                        style: AppTheme.black_14w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: AppTheme.greyText,
                                      ),
                                      onPressed: () {
                                        Get.dialog(CreatePrivatePromptDialog(
                                          promptItemModel: item,
                                        ));
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: AppTheme.greyText,
                                      ),
                                      onPressed: () {
                                        Get.dialog(ConfirmDeletePromptDialog(
                                          title: "prompt",
                                          onDelete: () {
                                            controller.deletePrompt(
                                                id: item.id!);
                                          },
                                        ));
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                            itemCount: controller.listPrompt.length +
                                (controller.isFetchingNewData.value ? 1 : 0),
                          ),
                  ),
          ),
        ],
      ),
    );
  }
}
