import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/data/datasources/kb_ai_assistant_datasource.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_assistant.dart';

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

  Future<bool> deleteKBAIAssistant({
    required String assistantId,
  }) {
    return dataSource.deleteKBAIAssistant(
      assistantId: assistantId,
    );
  }

  Future<List<KBAIAssistant>> getListKBAIAssistant({
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
}
