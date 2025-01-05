import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge/data/repository/knowledge_repository.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class DeleteUnitUsecase extends Usecase {
  final KnowledgeRepository _knowledgeRepository;
  const DeleteUnitUsecase({required KnowledgeRepository knowledgeRepository}) : _knowledgeRepository = knowledgeRepository;

  Future<void> run({required String idKl, required String idUnit}) async {
    return _knowledgeRepository.deleteUnitById(
      idKl: idKl,
      idUnit: idUnit,
    );
  }
}
