import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge/data/repository/knowledge_repository.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/request_knowledge_model.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/response_get_list_kl.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetKnowledgeUsecase extends Usecase {
  final KnowledgeRepository _knowledgeRepository;
  const GetKnowledgeUsecase({required KnowledgeRepository knowledgeRepository}) : _knowledgeRepository = knowledgeRepository;

  Future<ResponseGetListKl> run({required RequestKnowledgeModel queries}) async {
    return _knowledgeRepository.getKnowledge(
      queries: queries,
    );
  }
}
