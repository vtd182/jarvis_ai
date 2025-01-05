import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/data/datasources/services/kb_ai_assistant_service.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_assistant.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_knowledge.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_message.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_thread.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_response_with_pagination.dart';

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

  Future<String> deleteKBAIAssistant({
    required String assistantId,
  });

  Future<KBResponseWithPagination<KBAIAssistant>> getListKBAIAssistant({
    required String query,
    required String order,
    required String orderField,
    required int offset,
    required int limit,
    required bool isFavorite,
    required bool isPublished,
  });

  Future<String> importKnowledgeToKBAIAssistant({
    required String assistantId,
    required String knowledgeId,
  });

  Future<String> removeKnowledgeFromKBAIAssistant({
    required String assistantId,
    required String knowledgeId,
  });

  Future<KBResponseWithPagination<KBAIKnowledge>> getListKnowledgeOfKBAIAssistant({
    required String assistantId,
    required String query,
    required String order,
    required String orderField,
    required int offset,
    required int limit,
  });

  Future<KBAIThread> createKBAIThreadForAssistant({
    required String assistantId,
    required String firstMessage,
  });

  Future<KBAIThread> updateAssistantWithNewThreadPlayground({
    required String assistantId,
    required String firstMessage,
  });

  Future<String> askToKBAIAssistant({
    required String assistantId,
    required String message,
    required String openAiThreadId,
    required String additionalInstruction,
  });

  Future<List<KBAIMessage>> getMessagesOfKBAIThread({
    required String openAiThreadId,
    required String query,
    required String order,
    required String orderField,
    required int offset,
    required int limit,
  });

  Future<KBResponseWithPagination<KBAIThread>> getListKBAIThreadOfAssistant({
    required String assistantId,
    required String query,
    required String order,
    required String orderField,
    required int offset,
    required int limit,
  });

  Future<KBAIAssistant> favoriteKBAIAssistant({required String assistantId});
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
  Future<String> deleteKBAIAssistant({required String assistantId}) {
    return _kbAiAssistantService.deleteKBAIAssistant(assistantId);
  }

  @override
  Future<KBAIAssistant> getKBAIAssistant({required String assistantId}) {
    return _kbAiAssistantService.getKBAIAssistant(assistantId);
  }

  @override
  Future<KBResponseWithPagination<KBAIAssistant>> getListKBAIAssistant({
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

  @override
  Future<String> askToKBAIAssistant(
      {required String assistantId, required String message, required String openAiThreadId, required String additionalInstruction}) {
    return _kbAiAssistantService.askToKBAIAssistant(
      assistantId,
      {
        'message': message,
        'openAiThreadId': openAiThreadId,
        'additionalInstruction': additionalInstruction,
      },
    );
  }

  @override
  Future<KBAIThread> createKBAIThreadForAssistant({required String assistantId, required String firstMessage}) {
    return _kbAiAssistantService.createKBAIThreadForAssistant({
      'assistantId': assistantId,
      'firstMessage': firstMessage,
    });
  }

  @override
  Future<KBResponseWithPagination<KBAIThread>> getListKBAIThreadOfAssistant(
      {required String assistantId,
      required String query,
      required String order,
      required String orderField,
      required int offset,
      required int limit}) {
    return _kbAiAssistantService.getListKBAIThreadOfAssistant(
      assistantId,
      query,
      order,
      orderField,
      offset,
      limit,
    );
  }

  @override
  Future<KBResponseWithPagination<KBAIKnowledge>> getListKnowledgeOfKBAIAssistant(
      {required String assistantId,
      required String query,
      required String order,
      required String orderField,
      required int offset,
      required int limit}) {
    return _kbAiAssistantService.getListKnowledgeOfKBAIAssistant(
      assistantId,
      query,
      order,
      orderField,
      offset,
      limit,
    );
  }

  @override
  Future<List<KBAIMessage>> getMessagesOfKBAIThread(
      {required String openAiThreadId,
      required String query,
      required String order,
      required String orderField,
      required int offset,
      required int limit}) {
    return _kbAiAssistantService.getMessagesOfKBAIThread(
      openAiThreadId,
      query,
      order,
      orderField,
      offset,
      limit,
    );
  }

  @override
  Future<String> importKnowledgeToKBAIAssistant({required String assistantId, required String knowledgeId}) {
    return _kbAiAssistantService.importKnowledgeToKBAIAssistant(
      assistantId,
      knowledgeId,
    );
  }

  @override
  Future<String> removeKnowledgeFromKBAIAssistant({required String assistantId, required String knowledgeId}) {
    return _kbAiAssistantService.removeKnowledgeFromKBAIAssistant(
      assistantId,
      knowledgeId,
    );
  }

  @override
  Future<KBAIThread> updateAssistantWithNewThreadPlayground({required String assistantId, required String firstMessage}) {
    return _kbAiAssistantService.updateAssistantWithNewThreadPlayground({
      'assistantId': assistantId,
      'firstMessage': firstMessage,
    });
  }

  @override
  Future<KBAIAssistant> favoriteKBAIAssistant({required String assistantId}) {
    return _kbAiAssistantService.favoriteKBAIAssistant(assistantId);
  }
}
