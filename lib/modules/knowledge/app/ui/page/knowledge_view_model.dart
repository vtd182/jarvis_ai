import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/locator.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/page/kl_detail_page.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/request_create_kl.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/request_knowledge_model.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/response_get_kl.dart';
import 'package:jarvis_ai/modules/knowledge/domain/usecases/create_kl_usecase.dart';
import 'package:jarvis_ai/modules/knowledge/domain/usecases/delete_kl_usecase.dart';
import 'package:jarvis_ai/modules/knowledge/domain/usecases/get_knowledge_usecase.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_auth/domain/usecase/knowledge_base_sign_in_usecase.dart';
import 'package:jarvis_ai/modules/shared/theme/app_theme.dart';
import 'package:jarvis_ai/storage/spref.dart';

bool isSignInKnowledge = false;

class KnowledgeViewModel extends GetxController {
  final GetKnowledgeUsecase _getKnowledgeUsecase;
  final CreateKlUsecase _createKlUsecase;
  final DeleteKnowledgeUsecase _deleteKnowledgeUsecase;

  KnowledgeViewModel(
    this._getKnowledgeUsecase,
    this._createKlUsecase,
    this._deleteKnowledgeUsecase,
  );

  final isLoading = false.obs;
  final listKnowledge = <ResponseGetKl>[].obs;
  final searchController = TextEditingController();

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
      listKnowledge.clear();
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

  Future<void> getAllKnowledge({
    String? query,
    bool isLoadMore = false,
  }) async {
    try {
      if (!isSignInKnowledge) {
        isSignInKnowledge = true;
        await locator<KnowledgeBaseSignInUseCase>()
            .run(token: (await SPref.instance.getAccessToken()) ?? "");
      }

      bool canLoad = isCanLoadMore(isLoadMore);
      if (!canLoad) {
        return;
      }

      final res = await _getKnowledgeUsecase.run(
        queries: RequestKnowledgeModel(
          limit: 20,
          offset: pageIndex.value,
          q: query,
        ),
      );
      // handle add data
      hasNext.value = res.meta.hasNext;
      if (isLoadMore) {
        listKnowledge.addAll(res.data);
      } else {
        listKnowledge.value = res.data;
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

  Future<void> onCreateKl(String name, String? description) async {
    try {
      isLoading.value = true;
      await _createKlUsecase.run(
        body: RequestCreateKl(
            knowledgeName: name, description: description ?? ""),
      );
      Get.back();
      await getAllKnowledge();
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

  Future<void> deleteKnowledgeById({required String id}) async {
    try {
      isLoading.value = true;
      await _deleteKnowledgeUsecase.run(id: id + "3");
      Get.back();
      await getAllKnowledge();
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

  Future<void> onNavigateToKlDetail(ResponseGetKl kl) async {
    await Get.to(() => KlDetailPage(kl: kl));
    await getAllKnowledge();
  }
}
