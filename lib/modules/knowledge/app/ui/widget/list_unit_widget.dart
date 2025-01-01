import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/page/kl_detail_viewmodel.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/widget/unit_item.dart';
import 'package:jarvis_ai/modules/shared/theme/app_theme.dart';

class ListUnitWidget extends StatefulWidget {
  const ListUnitWidget({super.key});

  @override
  State<ListUnitWidget> createState() => _ListUnitWidgetState();
}

class _ListUnitWidgetState extends State<ListUnitWidget> {
  final controller = Get.find<KlDetailViewModel>();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    /// end of list listener
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.getUnitOfKl(isLoadMore: true);
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
    return Obx(
      () => controller.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              itemBuilder: (context, index) {
                // LOAD MORE
                if (index == controller.listUnits.length + 1) {
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
                          "Unit",
                          style: AppTheme.black_14w600.copyWith(color: AppTheme.primaryBlue),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          "Source",
                          style: AppTheme.black_14w600.copyWith(color: AppTheme.primaryBlue),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          "Enable",
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
                final item = controller.listUnits[index - 1];
                return UnitItem(item: item);
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: AppTheme.greyText.withOpacity(0.3),
                );
              },
              itemCount: controller.listUnits.length + 2,
            ),
    );
  }
}
