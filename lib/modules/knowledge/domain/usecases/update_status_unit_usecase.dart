import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge/data/repository/knowledge_repository.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/response_get_unit.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class UpdateStatusUnitUsecase extends Usecase {
  final KnowledgeRepository _knowledgeRepository;
  const UpdateStatusUnitUsecase({required KnowledgeRepository knowledgeRepository}) : _knowledgeRepository = knowledgeRepository;

  Future<ResponseGetUnit> run({required String id, required Map<String, dynamic> body}) async {
    return _knowledgeRepository.updateStatusUnit(
      id: id,
      body: body,
    );
  }
}
