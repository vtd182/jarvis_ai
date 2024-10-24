import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:jarvis_ai/core/styles/app_color.dart';
import 'package:jarvis_ai/core/styles/app_style.dart';
import 'package:jarvis_ai/modules/chat/presentation/controller/chat_controller.dart';

class PublicPromptTabViewItem extends StatefulWidget {
  const PublicPromptTabViewItem({super.key});

  @override
  State<PublicPromptTabViewItem> createState() => _PublicPromptTabViewItemState();
}

class _PublicPromptTabViewItemState extends State<PublicPromptTabViewItem> {
  final controller = Get.find<ChatController>();

  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // IconButton(
              //   onPressed: () {
              //   },
              //   icon: const Icon(Icons.search),
              //   color: Colors.grey,
              //   iconSize: 18,
              // ),
              Expanded(
                child: TextField(
                  controller: controller.publicPromptController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    fillColor: AppColor.greyBackground,
                    filled: true,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 22,
                    ),
                    hintText: "Search",
                    hintStyle: AppStyle.boldStyle(color: AppColor.greyText, fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 4,
                    ),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
                child: Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColor.greyText,
                    ),
                  ),
                  child: Icon(
                    Icons.favorite,
                    color: isFavorite ? Colors.red : Colors.grey,
                    size: 22,
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
              itemCount: controller.listCategoryPublicPrompt.length,
              itemBuilder: (context, index) {
                return Obx(() {
                  return InkWell(
                    onTap: () {
                      controller.indexCategoryPublicPrompt.value = index;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: controller.indexCategoryPublicPrompt.value == index ? AppColor.blueBold : AppColor.greyBackground,
                      ),
                      child: Text(
                        controller.listCategoryPublicPrompt[index],
                        style: AppStyle.boldStyle(
                          color: controller.indexCategoryPublicPrompt.value == index ? Colors.white : Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              "My Prompt ${index + 1}",
                              style: AppStyle.boldStyle(fontSize: 16),
                            ),
                            Text(
                              "Description",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyle.regularStyle(
                                color: AppColor.greyText,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(
                          Icons.favorite_border,
                          color: AppColor.greyText,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.info_outline,
                          color: AppColor.greyText,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: 5),
          ),
        ],
      ),
    );
  }
}
