import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:http_parser/http_parser.dart';
import 'package:jarvis_ai/config/config.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/widget/confluence_unit_dialog.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/widget/local_file_unit_dialog.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/widget/slack_unit_dialog.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/widget/website_unit_dialog.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/request_add_confluence.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/request_add_slack.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/request_add_url.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/request_knowledge_model.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/response_get_unit.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/unit_type_model.dart';
import 'package:jarvis_ai/modules/knowledge/domain/usecases/add_confluence_unit_usecase.dart';
import 'package:jarvis_ai/modules/knowledge/domain/usecases/add_slack_unit_usecase.dart';
import 'package:jarvis_ai/modules/knowledge/domain/usecases/add_url_unit_usecase.dart';
import 'package:jarvis_ai/modules/knowledge/domain/usecases/delete_unit_usecase.dart';
import 'package:jarvis_ai/modules/knowledge/domain/usecases/get_unit_of_kl_usecase.dart';
import 'package:file_picker/file_picker.dart';
import 'package:jarvis_ai/modules/knowledge/domain/usecases/update_status_unit_usecase.dart';
import 'package:jarvis_ai/modules/knowledge/domain/usecases/upload_local_file_usecase.dart';
import 'package:jarvis_ai/modules/shared/theme/app_theme.dart';
import 'package:jarvis_ai/storage/spref.dart';
import 'package:mime/mime.dart';

class KlDetailViewModel extends GetxController {
  final GetUnitOfKlUsecase _getUnitOfKlUsecase;
  final UploadLocalFileUsecase _uploadLocalFileUsecase;
  final AddUrlUnitUsecase _addUrlUnitUsecase;
  final AddSlackUnitUsecase _addSlackUnitUsecase;
  final AddConfluenceUnitUsecase _addConfluenceUnitUsecase;
  final Dio _dio;
  final UpdateStatusUnitUsecase _updateStatusUnitUsecase;
  final DeleteUnitUsecase _deleteUnitUsecase;

  KlDetailViewModel(
    this._getUnitOfKlUsecase,
    this._uploadLocalFileUsecase,
    this._addUrlUnitUsecase,
    this._addSlackUnitUsecase,
    this._addConfluenceUnitUsecase,
    this._dio,
    this._updateStatusUnitUsecase,
    this._deleteUnitUsecase,
  );

  final isLoading = false.obs;

  final listUnits = <ResponseGetUnit>[].obs;

  final localFile = Rx<File?>(null);

  final idKl = "".obs;

  final listTypeUnits = [
    UnitTypeModel(title: "Local files", description: "Upload pdf, docx,..."),
    UnitTypeModel(title: "Website", description: "Connect Website to get data"),
    UnitTypeModel(title: "Google Drive", description: "Connect Google Drive to get data"),
    UnitTypeModel(title: "Slack", description: "Connect Slack to get data"),
    UnitTypeModel(title: "Confluence", description: "Connect Confluence to get data"),
  ];

  final indexTypeUnit = 0.obs;

  // loading more
  final pageIndex = 0.obs;
  final isFetchingNewData = false.obs;
  final hasNext = true.obs;

  bool isCanLoadMore(bool isLoadMore) {
    if (isFetchingNewData.value) {
      return false;
    }

    if (!isLoadMore) {
      isLoading.value = true;
      listUnits.clear();
      pageIndex.value = 0;
      hasNext.value = true;
    } else {
      if (!hasNext.value) {
        return false;
      } else {
        isFetchingNewData.value = true;
        pageIndex.value += 20;
      }
    }

    return true;
  }

  Future<void> getUnitOfKl({
    bool isLoadMore = false,
  }) async {
    try {
      bool canLoad = isCanLoadMore(isLoadMore);
      if (!canLoad) {
        return;
      }

      final res = await _getUnitOfKlUsecase.run(
        id: idKl.value,
        queries: RequestKnowledgeModel(
          offset: pageIndex.value,
          limit: 20,
        ),
      );
      // handle add data
      hasNext.value = res.meta.hasNext;
      if (isLoadMore) {
        listUnits.addAll(res.data);
      } else {
        listUnits.value = res.data;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong! Try again",
        backgroundColor: AppTheme.red3,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
      isFetchingNewData.value = false;
    }
  }

  void onNavigateToAddUnit() {
    Get.back();
    if (indexTypeUnit.value == 0) {
      Get.dialog(
        const LocalFileUnitDialog(),
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.1),
      );
    } else if (indexTypeUnit.value == 1) {
      Get.dialog(
        WebsiteUnitDialog(),
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.1),
      );
    } else if (indexTypeUnit.value == 3) {
      Get.dialog(
        SlackUnitDialog(),
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.1),
      );
    } else if (indexTypeUnit.value == 4) {
      Get.dialog(
        ConfluenceUnitDialog(),
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.1),
      );
    }
  }

  Future<void> onSelectLocalFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    final listAllowedExtensions = ['c', 'cpp', 'docx', 'html', 'java', 'json', 'md', 'pdf', 'php', 'pptx', 'py', 'rb', 'tex', 'txt'];

    if (result != null) {
      final path = result.files.single.path;
      final fileName = result.files.single.name;
      final extension = fileName.split('.').last;
      if (listAllowedExtensions.contains(extension)) {
        localFile.value = File(path!);
      } else {
        Get.snackbar(
          "Error",
          "You cannot upload file $extension type",
          backgroundColor: AppTheme.red3,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    }
  }

  Future<void> onUploadLocalFile() async {
    try {
      if (localFile.value != null) {
        isLoading.value = true;
        final fileName = localFile.value!.path.split('/').last;
        final multiPartFileUpload = await MultipartFile.fromFile(
          localFile.value!.path,
          filename: fileName,
          contentType: MediaType.parse("${lookupMimeType(localFile.value!.path)}"),
        );
        FormData fileUpload = FormData.fromMap({
          "file": multiPartFileUpload,
        });

        await _dio.post(
          "${Config.knowledgeBaseUrl}/kb-core/v${Config.apiVersion}/knowledge/${idKl.value}/local-file",
          data: fileUpload,
        );

        await getUnitOfKl();

        Get.back();
      } else {
        Get.snackbar(
          "Error",
          "Please select file to upload",
          backgroundColor: AppTheme.red3,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong! Try again",
        backgroundColor: AppTheme.red3,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onAddWebUnit({required String unitName, required String webUrl}) async {
    try {
      isLoading.value = true;
      await _addUrlUnitUsecase.run(
        id: idKl.value,
        body: RequestAddUrl(unitName: unitName, webUrl: webUrl),
      );
      Get.back();
      await getUnitOfKl();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong! Try again",
        backgroundColor: AppTheme.red3,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onAddSlackUnit({required String unitName, required String slackWorkspace, required String slackBotToken}) async {
    try {
      isLoading.value = true;
      await _addSlackUnitUsecase.run(
        id: idKl.value,
        body: RequestAddSlack(unitName: unitName, slackWorkspace: slackWorkspace, slackBotToken: slackBotToken),
      );
      Get.back();
      await getUnitOfKl();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong! Try again",
        backgroundColor: AppTheme.red3,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onAddConfluenceUnit(
      {required String unitName, required String wikiPageUrl, required String confluenceUsername, required String confluenceAccessToken}) async {
    try {
      isLoading.value = true;
      await _addConfluenceUnitUsecase.run(
        id: idKl.value,
        body: RequestAddConfluence(
            unitName: unitName, wikiPageUrl: wikiPageUrl, confluenceUsername: confluenceUsername, confluenceAccessToken: confluenceAccessToken),
      );
      Get.back();
      await getUnitOfKl();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong! Try again",
        backgroundColor: AppTheme.red3,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteUnitById({required String id}) async {
    try {
      isLoading.value = true;
      await _deleteUnitUsecase.run(idKl: idKl.value, idUnit: id);
      Get.back();
      await getUnitOfKl();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong! Try again",
        backgroundColor: AppTheme.red3,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStatusUnit({required String id, required bool status}) async {
    try {
      isLoading.value = true;
      final acc = await SPref.instance.getKBAccessToken();
      print("tpoo acc $acc");
      print("tpoo id $id");
      await _updateStatusUnitUsecase.run(id: id, body: {"status": status});
      await getUnitOfKl();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong! Try again",
        backgroundColor: AppTheme.red3,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
