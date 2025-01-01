import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/locator.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/page/kl_detail_viewmodel.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/widget/list_unit_widget.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/widget/select_type_unit_dialog.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/response_get_kl.dart';
import 'package:jarvis_ai/modules/knowledge/domain/usecases/add_confluence_unit_usecase.dart';
import 'package:jarvis_ai/modules/knowledge/domain/usecases/add_slack_unit_usecase.dart';
import 'package:jarvis_ai/modules/knowledge/domain/usecases/add_url_unit_usecase.dart';
import 'package:jarvis_ai/modules/knowledge/domain/usecases/delete_kl_usecase.dart';
import 'package:jarvis_ai/modules/knowledge/domain/usecases/delete_unit_usecase.dart';
import 'package:jarvis_ai/modules/knowledge/domain/usecases/get_unit_of_kl_usecase.dart';
import 'package:jarvis_ai/modules/knowledge/domain/usecases/update_status_unit_usecase.dart';
import 'package:jarvis_ai/modules/knowledge/domain/usecases/upload_local_file_usecase.dart';
import 'package:jarvis_ai/modules/shared/theme/app_theme.dart';

class KlDetailPage extends StatelessWidget {
  KlDetailPage({super.key, required this.kl});
  final ResponseGetKl kl;

  final controller = Get.put(
    KlDetailViewModel(
      locator<GetUnitOfKlUsecase>(),
      locator<UploadLocalFileUsecase>(),
      locator<AddUrlUnitUsecase>(),
      locator<AddSlackUnitUsecase>(),
      locator<AddConfluenceUnitUsecase>(),
      locator<Dio>(),
      locator<UpdateStatusUnitUsecase>(),
      locator<DeleteUnitUsecase>(),
    ),
  );

  @override
  StatelessElement createElement() {
    controller.idKl.value = kl.id;
    controller.getUnitOfKl();
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          kl.knowledgeName,
          style: AppTheme.black_16bold,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.dialog(const SelectTypeUnitDialog());
            },
            child: Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: AppTheme.primaryLinearGradient),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.add,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: const ListUnitWidget(),
    );
  }
}
