import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge/data/repository/knowledge_repository.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/request_knowledge_model.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/response_get_list_unit.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetUnitOfKlUsecase extends Usecase {
  final KnowledgeRepository _knowledgeRepository;
  const GetUnitOfKlUsecase({required KnowledgeRepository knowledgeRepository})
      : _knowledgeRepository = knowledgeRepository;

  Future<ResponseGetListUnit> run(
      {required String id, required RequestKnowledgeModel queries}) async {
    return _knowledgeRepository.getUnitsOfKnowledge(
      id: id,
      queries: queries,
    );
  }
}
