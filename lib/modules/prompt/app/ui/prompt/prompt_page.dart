import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/ads/remote_config.dart';
import 'package:jarvis_ai/locator.dart';
import 'package:jarvis_ai/main.dart';
import 'package:jarvis_ai/modules/prompt/app/ui/prompt/prompt_view_model.dart';
import 'package:jarvis_ai/modules/prompt/app/ui/widget/private_prompt_tab_view_item.dart';
import 'package:jarvis_ai/modules/prompt/app/ui/widget/prompt_tab_bar_item.dart';
import 'package:jarvis_ai/modules/prompt/app/ui/widget/public_prompt_tab_view_item.dart';
import 'package:jarvis_ai/modules/prompt/domain/usecase/add_prompt_favorite_usecase.dart';
import 'package:jarvis_ai/modules/prompt/domain/usecase/create_prompt_usecase.dart';
import 'package:jarvis_ai/modules/prompt/domain/usecase/delete_prompt_usecase.dart';
import 'package:jarvis_ai/modules/prompt/domain/usecase/get_prompt_usecase.dart';
import 'package:jarvis_ai/modules/prompt/domain/usecase/remove_prompt_favorite_usecase.dart';
import 'package:jarvis_ai/modules/prompt/domain/usecase/update_prompt_usecase.dart';
import 'package:jarvis_ai/modules/shared/theme/app_theme.dart';

class PromptPage extends StatelessWidget {
  PromptPage({super.key});

  final controller = Get.put(
    PromptViewModel(
      locator<GetPromptUsecase>(),
      locator<AddPromptFavoriteUsecase>(),
      locator<CreatePromptUsecase>(),
      locator<DeletePromptUsecase>(),
      locator<RemovePromptFavoriteUsecase>(),
      locator<UpdatePromptUsecase>(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.grey,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: PromptTabBarItem(
                            index: 0,
                            title: "My Prompt",
                          ),
                        ),
                        Expanded(
                          child: PromptTabBarItem(
                            index: 1,
                            title: "Public Prompt",
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => controller.indexTabPromt.value == 0
                        ? const PrivatePromptTabViewItem()
                        : const PublicPromptTabViewItem(),
                  ),
                ],
              ),
            ),
          ),
          EasyBannerAd(
            adId: adIdManager.banner_all,
            config: RemoteConfig.banner_all,
            visibilityDetectorKey: "${runtimeType}banner_all",
            type: EasyAdsBannerType.adaptive,
          ),
        ],
      ),
    );
  }
}
