import 'package:get/get.dart';
import 'package:jarvis_ai/modules/prompt/domain/model/prompt_item_model.dart';
import 'package:jarvis_ai/modules/prompt/domain/model/prompts_response_model.dart';
import 'package:jarvis_ai/modules/prompt/domain/usecase/add_prompt_favorite_usecase.dart';
import 'package:jarvis_ai/modules/prompt/domain/usecase/create_prompt_usecase.dart';
import 'package:jarvis_ai/modules/prompt/domain/usecase/delete_prompt_usecase.dart';
import 'package:jarvis_ai/modules/prompt/domain/usecase/get_prompt_usecase.dart';
import 'package:jarvis_ai/modules/prompt/domain/usecase/remove_prompt_favorite_usecase.dart';
import 'package:jarvis_ai/modules/prompt/domain/usecase/update_prompt_usecase.dart';
import 'package:jarvis_ai/storage/spref.dart';
import 'package:suga_core/suga_core.dart';

class PromptViewModel extends GetxController {
  final GetPromptUsecase _getPromptUsecase;
  final AddPromptFavoriteUsecase _addPromptFavoriteUsecase;
  final CreatePromptUsecase _createPromptUsecase;
  final DeletePromptUsecase _deletePromptUsecase;
  final RemovePromptFavoriteUsecase _removePromptFavoriteUsecase;
  final UpdatePromptUsecase _updatePromptUsecase;

  PromptViewModel(
      this._getPromptUsecase,
      this._addPromptFavoriteUsecase,
      this._createPromptUsecase,
      this._deletePromptUsecase,
      this._removePromptFavoriteUsecase,
      this._updatePromptUsecase);

  final indexTabPromt = 0.obs;
  final isLoading = false.obs;
  final listPrompt = <PromptItemModel>[].obs;
  final isGetFavorite = false.obs;
  final indexCategory = 0.obs;

  // loading more
  final pageIndex = 0.obs;
  final isFetchingNewData = false.obs;
  final hasNext = true.obs;

  final listPromptCategory = [
    "All",
    "Business",
    "Career",
    "Chatbot",
    "Coding",
    "Education",
    "Fun",
    "Marketing",
    "Productivity",
    "Seo",
    "Writing",
    "Other",
  ];

  bool isCanLoadMore(bool isLoadMore) {
    if (isFetchingNewData.value) {
      return false;
    }

    if (!isLoadMore) {
      isLoading.value = true;
      listPrompt.clear();
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

  Future<Unit> getPublicPrompt({
    required String query,
    bool isLoadMore = false,
  }) async {
    try {

      bool canLoad = isCanLoadMore(isLoadMore);
      if (!canLoad) {
        return unit;
      }

      final queries = {
        "query": query,
        "isFavorite": isGetFavorite.value,
        "isPublic": true,
        "offset": pageIndex.value,
        "limit": 20,
      };

      if (indexCategory.value != 0) {
        queries["category"] =
            listPromptCategory[indexCategory.value].toLowerCase();
      }

      final result = await _getPromptUsecase.run(
        queries: queries,
      );

      final promptResponse = PromptsResponseModel.fromJson(result);
      hasNext.value = promptResponse.hasNext ?? true;
      if (indexTabPromt.value == 1) {
        if (isLoadMore) {
          listPrompt.addAll(promptResponse.items ?? []);
        } else {
          listPrompt.value = promptResponse.items ?? [];
        }
      }

      isLoading.value = false;
      isFetchingNewData.value = false;
    } catch (e) {
      isLoading.value = false;
      isFetchingNewData.value = false;
      print("Error during getPrompt: $e");
    } finally {
      isLoading.value = false;
      isFetchingNewData.value = false;
    }
    return unit;
  }

  Future<void> getPrivatePrompt({
    String query = "",
    bool isLoadMore = false,
  }) async {
    try {
      bool canLoad = isCanLoadMore(isLoadMore);
      if (!canLoad) {
        return;
      }

      final result = await _getPromptUsecase.run(queries: {
        "query": query,
        "isPublic": false,
        "offset": pageIndex.value,
        "limit": 20,
      });

      final promptResponse = PromptsResponseModel.fromJson(result);
      hasNext.value = promptResponse.hasNext ?? true;
      if (indexTabPromt.value == 0) {
        if (isLoadMore) {
          listPrompt.addAll(promptResponse.items ?? []);
        } else {
          listPrompt.value = promptResponse.items ?? [];
        }
      }

      isLoading.value = false;
      isFetchingNewData.value = false;
    } catch (e) {
      isLoading.value = false;
      isFetchingNewData.value = false;
      print("Error during getPrivatePrompt: $e");
    }
  }

  Future<void> createPrivatePrompt(
      {required String title, required String content}) async {
    try {
      isLoading.value = true;
      await _createPromptUsecase.run(
          title: title,
          content: content,
          category: "other",
          isPublic: false,
          language: "English",
          description: "");
      Get.back();
      await getPrivatePrompt();
      isLoading.value = false;
    } catch (e) {
      Get.back();
      isLoading.value = false;
      print("Error during createPrivatePrompt: $e");
    }
  }

  Future<void> updatePrompt({
    required PromptItemModel item,
  }) async {
    try {
      isLoading.value = true;
      await _updatePromptUsecase.run(
        id: item.id!,
        title: item.title,
        content: item.content,
        category: "other",
        isPublic: false,
        description: item.description ?? "",
        language: item.language ?? "English",
      );
      Get.back();
      await getPrivatePrompt();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print("Error during updatePrompt: $e");
    }
  }

  Future<void> toggleFavoritePrompt({
    required String id,
  }) async {
    try {
      final index = listPrompt.indexWhere((element) => element.id == id);
      if (index != -1) {
        if (listPrompt[index].isFavorite == true) {
          await _removePromptFavoriteUsecase.run(id: id);
          listPrompt[index] = listPrompt[index].copyWith(isFavorite: false);
        } else {
          await _addPromptFavoriteUsecase.run(id: id);
          listPrompt[index] = listPrompt[index].copyWith(isFavorite: true);
        }
      }
    } catch (e) {
      print("Error during addPromptToFavorite: $e");
    }
  }

  Future<void> deletePrompt({
    required String id,
  }) async {
    try {
      isLoading.value = true;
      await _deletePromptUsecase.run(id: id);
      Get.back();
      await getPrivatePrompt();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print("Error during deletePrompt: $e");
    }
  }
}
