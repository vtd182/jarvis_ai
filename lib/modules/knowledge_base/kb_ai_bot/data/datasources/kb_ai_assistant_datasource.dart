import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/data/datasources/services/kb_ai_assistant_service.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_assistant.dart';

abstract class KBAIAssistantDataSource {
  Future<KBAIAssistant> createKBAIAssistant({
    required String assistantName,
    required String instructions,
    required String description,
  });

  Future<KBAIAssistant> updateKBAIAssistant({
    required String assistantId,
    required String assistantName,
    required String instructions,
    required String description,
  });

  Future<KBAIAssistant> getKBAIAssistant({
    required String assistantId,
  });

  Future<bool> deleteKBAIAssistant({
    required String assistantId,
  });

  Future<List<KBAIAssistant>> getListKBAIAssistant({
    required String query,
    required String order,
    required String orderField,
    required int offset,
    required int limit,
    required bool isFavorite,
    required bool isPublished,
  });
}

@LazySingleton(as: KBAIAssistantDataSource)
class KBAIAssistantDataSourceImp implements KBAIAssistantDataSource {
  final KBAIAssistantService _kbAiAssistantService;

  KBAIAssistantDataSourceImp(this._kbAiAssistantService);
  @override
  Future<KBAIAssistant> createKBAIAssistant({
    required String assistantName,
    required String instructions,
    required String description,
  }) {
    return _kbAiAssistantService.createKBAIAssistant({
      'assistantName': assistantName,
      'instructions': instructions,
      'description': description,
    });
  }

  @override
  Future<bool> deleteKBAIAssistant({required String assistantId}) {
    return _kbAiAssistantService.deleteKBAIAssistant(assistantId);
  }

  @override
  Future<KBAIAssistant> getKBAIAssistant({required String assistantId}) {
    return _kbAiAssistantService.getKBAIAssistant(assistantId);
  }

  @override
  Future<List<KBAIAssistant>> getListKBAIAssistant({
    required String query,
    required String order,
    required String orderField,
    required int offset,
    required int limit,
    required bool isFavorite,
    required bool isPublished,
  }) {
    return _kbAiAssistantService.getListKBAIAssistant(
      query,
      order,
      orderField,
      offset,
      limit,
      isFavorite,
      isPublished,
    );
  }

  @override
  Future<KBAIAssistant> updateKBAIAssistant({
    required String assistantId,
    required String assistantName,
    required String instructions,
    required String description,
  }) {
    return _kbAiAssistantService.updateKBAIAssistant(
      assistantId,
      {
        'assistantName': assistantName,
        'instructions': instructions,
        'description': description,
      },
    );
  }
}
