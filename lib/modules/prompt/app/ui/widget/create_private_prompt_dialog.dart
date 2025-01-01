import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_widget_cache.dart';
import 'package:jarvis_ai/ads/remote_config.dart';
import 'package:jarvis_ai/main.dart';
import 'package:jarvis_ai/modules/prompt/app/ui/prompt/prompt_view_model.dart';
import 'package:jarvis_ai/modules/prompt/domain/model/prompt_item_model.dart';
import 'package:jarvis_ai/modules/shared/theme/app_theme.dart';

class CreatePrivatePromptDialog extends GetWidget<PromptViewModel> {
  CreatePrivatePromptDialog({super.key, this.promptItemModel});

  final PromptItemModel? promptItemModel;

  @override
  GetWidgetCacheElement createElement() {
    if (promptItemModel != null) {
      titleTextController.text = promptItemModel!.title ?? "";
      contentTextController.text = promptItemModel!.content ?? "";
    }
    return super.createElement();
  }

  final titleTextController = TextEditingController();
  final contentTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Name",
                style: AppTheme.black_14w600,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: titleTextController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppTheme.grey,
                  filled: true,
                  hintText: "Name of the prompt",
                  hintStyle: AppTheme.grey1_14w400,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                textAlignVertical: TextAlignVertical.top,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Text(
                "Prompt",
                style: AppTheme.black_14w600,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.grey,

                  borderRadius: BorderRadius.circular(16),
                  // color: AppColor.primary,
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      const WidgetSpan(
                        child: Icon(
                          Icons.warning_amber_outlined,
                          color: AppTheme.primaryBlue,
                          size: 16,
                        ),
                      ),
                      TextSpan(
                        text: " Use square brackets [] to specify user input.",
                        style: AppTheme.black_12w400,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: contentTextController,
                maxLines: 4,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppTheme.grey,
                  filled: true,
                  hintMaxLines: 2,
                  hintText:
                      "e.g: Write an article [TOPIC], make sure to inclue these keywords: [KEYWORDS]",
                  hintStyle: AppTheme.grey1_14w400,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                textAlignVertical: TextAlignVertical.top,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: AppTheme.black_14w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: controller.isLoading.value
                        ? null
                        : () {
                            if (formKey.currentState!.validate()) {
                              void onSaveButton() {
                                promptItemModel != null
                                    ? controller.updatePrompt(
                                        item: promptItemModel!.copyWith(
                                          title: titleTextController.text,
                                          content: contentTextController.text,
                                        ),
                                      )
                                    : controller.createPrivatePrompt(
                                        title: titleTextController.text,
                                        content: contentTextController.text,
                                      );
                              }

                              EasyAds.instance.showInterstitialAd(
                                adId: adIdManager.inter_create_prompt,
                                config: RemoteConfig.inter_create_prompt,
                                onAdFailedToLoad: (adNetwork, adUnitType, data,
                                    errorMessage) {
                                  onSaveButton();
                                },
                                onAdFailedToShow: (adNetwork, adUnitType, data,
                                    errorMessage) {
                                  onSaveButton();
                                },
                                onAdLoaded: (adNetwork, adUnitType, data) {
                                  onSaveButton();
                                },
                                onDisabled: () {
                                  onSaveButton();
                                },
                              );
                            }
                          },
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: AppTheme.primaryLinearGradient),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Obx(
                        () => controller.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                "Save",
                                style: AppTheme.white_14w600,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
