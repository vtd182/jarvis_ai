import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge/data/repository/knowledge_repository.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class DeleteKnowledgeUsecase extends Usecase {
  final KnowledgeRepository _knowledgeRepository;
  const DeleteKnowledgeUsecase({required KnowledgeRepository knowledgeRepository}) : _knowledgeRepository = knowledgeRepository;

  Future<void> run({required String id}) async {
    return _knowledgeRepository.deleteKnowledge(
      id: id,
    );
  }
}
