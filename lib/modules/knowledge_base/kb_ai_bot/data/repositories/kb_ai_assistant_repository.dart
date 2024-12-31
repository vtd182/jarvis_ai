import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/data/datasources/kb_ai_assistant_datasource.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_assistant.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_knowledge.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_message.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_thread.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_response_with_pagination.dart';

@lazySingleton
class KBAIAssistantRepository {
  final KBAIAssistantDataSource dataSource;

  KBAIAssistantRepository(this.dataSource);

  Future<KBAIAssistant> createKBAIAssistant({
    required String assistantName,
    required String instructions,
    required String description,
  }) {
    return dataSource.createKBAIAssistant(
      assistantName: assistantName,
      instructions: instructions,
      description: description,
    );
  }

  Future<KBAIAssistant> updateKBAIAssistant({
    required String assistantId,
    required String assistantName,
    required String instructions,
    required String description,
  }) {
    return dataSource.updateKBAIAssistant(
      assistantId: assistantId,
      assistantName: assistantName,
      instructions: instructions,
      description: description,
    );
  }

  Future<KBAIAssistant> getKBAIAssistant({
    required String assistantId,
  }) {
    return dataSource.getKBAIAssistant(
      assistantId: assistantId,
    );
  }

  Future<String> deleteKBAIAssistant({
    required String assistantId,
  }) {
    return dataSource.deleteKBAIAssistant(
      assistantId: assistantId,
    );
  }

  Future<KBResponseWithPagination<KBAIAssistant>> getListKBAIAssistant({
    required String query,
    required String order,
    required String orderField,
    required int offset,
    required int limit,
    required bool isFavorite,
    required bool isPublished,
  }) {
    return dataSource.getListKBAIAssistant(
      query: query,
      order: order,
      orderField: orderField,
      offset: offset,
      limit: limit,
      isFavorite: isFavorite,
      isPublished: isPublished,
    );
  }

  Future<String> askToKBAIAssistant({
    required String assistantId,
    required String message,
    required String openAiThreadId,
    required String additionalInstruction,
  }) {
    return dataSource.askToKBAIAssistant(
      assistantId: assistantId,
      message: message,
      openAiThreadId: openAiThreadId,
      additionalInstruction: additionalInstruction,
    );
  }

  Future<KBAIThread> createKBAIThreadForAssistant({required String assistantId, required String firstMessage}) {
    return dataSource.createKBAIThreadForAssistant(
      assistantId: assistantId,
      firstMessage: firstMessage,
    );
  }

  Future<KBResponseWithPagination<KBAIThread>> getListKBAIThreadOfAssistant(
      {required String assistantId,
      required String query,
      required String order,
      required String orderField,
      required int offset,
      required int limit}) {
    return dataSource.getListKBAIThreadOfAssistant(
      assistantId: assistantId,
      query: query,
      order: order,
      orderField: orderField,
      offset: offset,
      limit: limit,
    );
  }

  Future<KBResponseWithPagination<KBAIKnowledge>> getListKnowledgeOfKBAIAssistant(
      {required String assistantId,
      required String query,
      required String order,
      required String orderField,
      required int offset,
      required int limit}) {
    return dataSource.getListKnowledgeOfKBAIAssistant(
      assistantId: assistantId,
      query: query,
      order: order,
      orderField: orderField,
      offset: offset,
      limit: limit,
    );
  }

  Future<List<KBAIMessage>> getMessagesOfKBAIThread({
    required String openAiThreadId,
    required String query,
    required String order,
    required String orderField,
    required int offset,
    required int limit,
  }) {
    return dataSource.getMessagesOfKBAIThread(
      openAiThreadId: openAiThreadId,
      query: query,
      order: order,
      orderField: orderField,
      offset: offset,
      limit: limit,
    );
  }

  Future<bool> importKnowledgeToKBAIAssistant({
    required String assistantId,
    required String knowledgeId,
  }) {
    return dataSource.importKnowledgeToKBAIAssistant(
      assistantId: assistantId,
      knowledgeId: knowledgeId,
    );
  }

  Future<bool> removeKnowledgeFromKBAIAssistant({
    required String assistantId,
    required String knowledgeId,
  }) {
    return dataSource.removeKnowledgeFromKBAIAssistant(
      assistantId: assistantId,
      knowledgeId: knowledgeId,
    );
  }

  Future<KBAIThread> updateAssistantWithNewThreadPlayground({
    required String assistantId,
    required String firstMessage,
  }) {
    return dataSource.updateAssistantWithNewThreadPlayground(
      assistantId: assistantId,
      firstMessage: firstMessage,
    );
  }
}
